Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:52454 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYELQub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:50:31 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3570259waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 12 May 2008 09:50:31 -0700 (PDT)
Message-ID: <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com> (sfid-20080512_185037_855308_E26DEB14)
Date: Mon, 12 May 2008 19:50:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091423y680b6706ta124eaaed73c81c0@mail.gmail.com>
	 <1210376474.3856.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 11, 2008 at 5:49 AM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
>
> On Sun, 2008-05-11 at 01:06 +0300, Tomas Winkler wrote:
>> On Sun, May 11, 2008 at 12:48 AM, Vincent C Jones
>> <v.jones@networkingunlimited.com> wrote:
>> >
>> > On Sat, 2008-05-10 at 21:56 +0300, Tomas Winkler wrote:
>> >> >
>> >> > May be more to this than just missing 802.11a channel reporting...
>> >> > walked to within range of a NetGear dual-band 802.11N 5GHz/11G 2.4GHz AP
>> >> > and could not even see the 802.11A side of the AP, (while another
>> >> > machine was associated with it, so both halves of the AP were up).
>> >> > I associated on the G channel, then tried to force an association on the
>> >> > A channel by setting the frequency with iwconfig. At some point, I got
>> >> > the following (note that I could still associate with the G channel when
>> >> > done):
>> >> >
>> >> > ay 10 11:20:04 X61 kernel: ------------[ cut here ]------------
>> >> > May 10 11:20:04 X61 kernel: WARNING: at
>> >> > include/../net/mac80211/rate.h:153 rs_get_rate+0x159/0x194 [iwl4965]()
>> >>
>> >> Something went wrong with station management.  Do you use same BSSID
>> >> on the both interfaces A and G?
>> >>
>> >> Thanks
>> >> Tomas
>> >
>> > No.
>> > 1st Floor-NetGear Dual Band AGN A/N on 36, BSSID = NetworkingUnlimited
>> >                                  G on 11, BSSID = NetworkingUnlimited-G
>> > 2nd Floor - 3Com POE A/G in A modeA on 48, BSSID = NetworkingUnlimited
>> >
>>
>> I'm asking for BSSID like mac address not SSID like network name
>> Thanks
>> Tomas
>
> Oops, my bad... According to iwlist scan under 2.6.25, the BSSIDs are
> unique:

Meanwhile we've reproduced the wpa_supplicant issue...

Thanks
Tomas
