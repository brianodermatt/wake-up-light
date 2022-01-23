const UPDATE_URL = "/api/update";
const TIME_REGEX = /^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$/; // HH:MM 24-hour with leading 0
const DAYS = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"];
const MONDAY = DAYS[0];
const WORKING_DAYS = DAYS.slice(0, 5);
const FIELDS = ['active', 'time', 'duration'];

/** Event handler for clicking the save button. Send the form date to the server */
async function save() {
  try {
    // There is an input group contained in a div .day-container #day-container-{{ day }} for each weekday
    const dayContainers = Array.from(document.querySelectorAll(".day-container"));

    // find the form data for each day
    const dayData = Object.fromEntries(dayContainers.map(dayContainer => {
      const day = dayContainer.id.split('-')[2];
      return [day, getDataForDay(day)];
    }));

    const res = await fetch(UPDATE_URL, {
      method: 'POST',
      body: JSON.stringify(dayData),
      headers: {
        'Content-Type': 'application/json'
      },
    });
    if (!res.ok) throw new Error(`Request failed: Status ${ res.status } ${ res.statusText }`);

    showToast('save-success');
  } catch (e) {
    error(e);
  }
}

/** Fill all working days with the value of monday */
function fillWorkingDays() {
  try {
    const mondayData = getDataForDay(MONDAY);

    WORKING_DAYS.forEach(day => {
      setDataForDay(day, mondayData);
    });
  } catch (e) {
    error(e);
  }
}


/********************/
/* Helper functions */
/********************/

/** Extract the form data for a day */
function getDataForDay(day) {
  const active = document.getElementById(`${day}-active`)?.checked;
  const time = document.getElementById(`${day}-time`)?.value;
  const duration = Number(document.getElementById(`${day}-duration`)?.value);

  // validation
  if (typeof active !== 'boolean') throw new TypeError(`'active' must be boolean but is: ${active}`);
  if (typeof time !== 'string' || !time.match(TIME_REGEX)) throw new TypeError(`'time' must be string hh:mm but is: ${time}`);
  if (typeof duration !== 'number' || duration <= 0 || !Number.isFinite(duration) || !Number.isSafeInteger(duration)) throw new TypeError(`'duration' must be finite integer > 0 but is: ${duration}`);

  return { active, time, duration };
}

function setDataForDay(day, data) {
  FIELDS.forEach(field => {
    const input = document.getElementById(`${day}-${field}`);
    if (!input) throw new ReferenceError(`'${field}' input not found for day: ${day}`);

    // for checkboxes, set checked instead of value
    if (field === 'active') {
      input.checked = data[field];
    } else {
      input.value = data[field];
    }
  });
}

/** Log an error and show toast */
function error(e, msg = '') {
  if (msg) console.error(msg);
  console.error(e);
  showToast('error', `ERROR ${msg}: ${ JSON.stringify(e) }`);
}


/********************/
/* Toasts           */
/********************/
// initialize toasts
window.addEventListener('load', () => {
  const toastElList = [].slice.call(document.querySelectorAll('.toast'));
  toastElList.forEach(toastEl => new bootstrap.Toast(toastEl));
});

/**
 * Show a toast.
 * Toast elements are found in the HTML by their id: toast-{{ name }}
 * If content is specified, it is used in the .custom-content element inside the toast
 */
function showToast(name, content = '') {
  const el = document.getElementById(`toast-${ name }`);
  if (!el) throw new ReferenceError(`toast element not found for '${ name }'`);

  const toast = bootstrap.Toast.getInstance(el);
  if (!toast) throw new ReferenceError(`toast instance not found for '${ name }'`);

  if (content) {
    const contentEl = el.querySelector('.custom-content');
    if (!contentEl) throw new ReferenceError(`sub-element with class 'custom-content' not found for '${ name }' but required for displaying custom content`);
    contentEl.textContent = content;
  }

  toast.show();
}

