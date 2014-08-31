Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:44128 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaHaR0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 13:26:36 -0400
Received: by mail-la0-f46.google.com with SMTP id pv20so4980912lab.19
        for <linux-wireless@vger.kernel.org>; Sun, 31 Aug 2014 10:26:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140829145002.GA28486@sig21.net>
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>
	<53D7AEF5.5040907@lwfinger.net>
	<alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org>
	<20140730110829.GA3563@sig21.net>
	<20140829145002.GA28486@sig21.net>
Date: Sun, 31 Aug 2014 20:26:34 +0300
Message-ID: <CANUX_P0aUiv+1_bitXTNPpODU55fA74oZ2X_MWOf0dXRUSOvTA@mail.gmail.com> (sfid-20140831_192735_432319_AE0B671B)
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: Nate Carlson <linux-wireless@natecarlson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Borislav Boev <borislavboev@hotmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2014 at 5:50 PM, Johannes Stezenbach <js@sig21.net> wrote:
> On Wed, Jul 30, 2014 at 01:08:30PM +0200, Johannes Stezenbach wrote:
>> The question is how to go about testing.  ISTR the Windows 8 driver
>> didn't have any issue and gave decent speed, but I don't have the
>> time to restore the Windows image for testing now.  If Windows
>> and Linux use the same firmware I guess a comparison would
>> reveal if it's a driver of firmware issue.
>
> I had some spare time today to restore the Windows 8 image
> and test (praise Clonezilla!).  The test is with an AP which
> (sometimes) sends broken beacons, so the result might not be viewed
> as valid by some, but I'm just comparing performance of
> different hardware and software under the same conditions.
> https://bugzilla.kernel.org/show_bug.cgi?id=78101
>
> Earlier today I could connect with Linux and the
> Dual Band Wireless-AC 7260 gave me <50KB/s download
> speed (fetching kernel tarball from PC connected via
> 1G ethernet to the AP).  An rt2800 usb dongle on the
> same machine gave me ~2.5MB/s.  Currently Linux
> cannot connect at all (see bug 78101) due to the
> broken beacon.
>
> With Windows 8 (Driver Version 16.10.0.5, Driver Date 1/28/2014)
> I had no problems to connect, and got ~400KB/s download speed.
> (I confirmed via capture on the PC that the beacons
> were broken in the way described in bug 78101 during this test.)
> The rt2800 usb dongle gave me 2.4MB/s in Windows.
>
> I couldn't reboot the AP today to see if and how much
> the performance improves when the beacons are not broken.
> I'll do that when I have time.  In the past, rebooting
> the AP did fix the connection issue (good beacon for some time),
> but did not turn the AC 7260 into a speed demon with the
> Linux driver.
>
> The AP only supports 2.4Ghz band 802.11n.
>
>> Otherwise I'm hoping Intel guys could provide some guidance for
>> testing so we could find the root cause.
>
> So far Intel did not show much interest in the issue, but
> a laptop user often has no control on the AP (travelling,
> hotels, conferences, etc.).  IMHO Intel would their users
> a big favor if they spent some time optimizing for bad
> network conditions.  The broken AP on my side will be
> replaced soon, but that's not the point of my complaint.
>
>

So far - I was busy with other stuff - and will still be.
After all, debugging issues we have with a completely broken AP isn't
my top priority.
And just for the record - can you share the progress you are having
with the AP manufacturer? After all - this is the real bug - but you
seem to complain about Intel more than the AP manufacturer... Strange
isn't it?
