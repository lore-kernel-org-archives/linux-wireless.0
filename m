Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s9.bay0.hotmail.com ([65.54.246.209]:36541 "EHLO
	bay0-omc3-s9.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbYIFThX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 15:37:23 -0400
Message-ID: <BAY118-W35E84AAD3187213E9B24F6DB5B0@phx.gbl> (sfid-20080906_213729_319379_FBAE820F)
From: Greg White <pcguy11@live.com>
To: =?iso-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: rt2x00 and packet injection
Date: Sat, 6 Sep 2008 14:37:22 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Sat, Sep 6, 2008 at 2:34 AM, Greg wrote:
>>
>> Hi,
>>
>> What is the status of packet injection in the rt2x00 driver? From my testing of 2.6.27 rc3 and reading 2.6.27 doesn't seem likely. Is there a todo list in priority order?
>>
>> Thanks,
>>
>
> I don't know about other sub-drivers, but rt73usb has no problems with
> packet injection whatsoever. As with all other mac80211-based drivers,
> an injector application with Radiotap header support is required.
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)

I tried aircrack-ng and 2.6.27-rc3 and the two don't want to work together.  Yes I dowloaded and compiled iw and libnl.  I have to use the driver from http://homepages.tu-darmstadt.de/~p_larbig/wlan/ to get aircrack-ng to work right.  Any suggestions?

Thanks,

_________________________________________________________________
Get more out of the Web. Learn 10 hidden secrets of Windows Live.
http://windowslive.com/connect/post/jamiethomson.spaces.live.com-Blog-cns!550F681DAD532637!5295.entry?ocid=TXT_TAGLM_WL_domore_092008