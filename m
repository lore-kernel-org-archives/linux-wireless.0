Return-path: <netrolller.3d@gmail.com>
MIME-Version: 1.0
In-Reply-To: <43e72e890907271241m7ccf386aj97097bb715e32658@mail.gmail.com>
References: <1248721179-16079-1-git-send-email-lrodriguez@atheros.com>
	<1248721724.32365.1.camel@johannes.local> <43e72e890907271241m7ccf386aj97097bb715e32658@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 27 Jul 2009 22:22:09 +0200
Message-ID: <69e28c910907271322x6c6ea95cr1cd1d310bf0ebe9b@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: redefine usage of the mac80211 workqueue
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 27, 2009 at 9:41 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:
> On Mon, Jul 27, 2009 at 12:08 PM, Johannes
> Berg<johannes@sipsolutions.net> wrote:
>> On Mon, 2009-07-27 at 11:59 -0700, Luis R. Rodriguez wrote:
>>
>>> +EXPORT_SYMBOL_GPL(ieee80211_queue_work);
>>
>> Do we really want to allow these as _GPL only? Most things are not _GPL
>> but usable by anyone, which of course isn't too useful since mac80211
>> changes all the time :)
>
> Well I don't see why not.
>
> =A0Luis

Do we want to prevent non-GPL drivers from using mac80211? That's
actually counter-productive, as it reduces the chance of a
manufacturer ever releasing a useful, kernel-includable driver. (Most
manufacturers initially develop non-GPL drivers, which hopefully end
up getting released under the GPL after community persuasion. If we
make mac80211 GPL-only, that prevents any internal driver based on
mac80211 from getting written.)

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
