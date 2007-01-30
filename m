Return-path: <wireless-bounces@tuxdriver.com>
Received: from fencepost.gnu.org (fencepost.gnu.org [199.232.76.164])
	by ra.tuxdriver.com (8.13.7/8.13.7) with ESMTP id l0UMP0tu029210
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <wireless@lists.tuxdriver.org>; Tue, 30 Jan 2007 17:25:26 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
 id 1HC1OT-0002cM-0M	for wireless@lists.tuxdriver.org; Tue,
 30 Jan 2007 17:24:01 -0500
Date: Tue, 30 Jan 2007 17:24:57 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: Re: Getting dscape running
In-reply-to: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
Sender: wireless-bounces@tuxdriver.com
To: Jon Smirl <jonsmirl@gmail.com>
Cc: wireless@lists.tuxdriver.org
Errors-to: wireless-bounces@tuxdriver.com
Message-id: <1170195897.11455.6.camel@dv>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
References: <9e4733910701301415p2ce1042aqcd833c732bc761cb@mail.gmail.com>
List-Post: <mailto:wireless@lists.tuxdriver.org>
List-Subscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=subscribe>
List-Unsubscribe: <http://lists.tuxdriver.org/mailman/listinfo/wireless>,
	<mailto:wireless-request@lists.tuxdriver.org?subject=unsubscribe>
List-Archive: <http://lists.tuxdriver.org/pipermail/wireless>
List-Help: <mailto:wireless-request@lists.tuxdriver.org?subject=help>
List-Id: Linux wireless networking development <wireless.lists.tuxdriver.org>

Hello, Jon!

On Tue, 2007-01-30 at 17:15 -0500, Jon Smirl wrote:
> I'd like to get a basic connection working on my system so that I can
> check out the dscape stack and do some work on it. I am targeting an
> embedded system using USB dongles but right now I am working on my
> desktop. Hopefully this new list can provide the guidance that I need.
> 
> I have NetworkManager from CVS and the current version of
> wpa_supplicant running. Hardware is a rt2570 dongle using the dscape
> stack. OS is Ubuntu.
> 
> When I use NetworkManager to switch to the wireless device it fails.
> It says the access point is unencrypted when it is running actually
> WEP. The problem is probably caused by the NULL gobject reference.
> What's causing this?

The mailing list for NetworkManager is networkmanager-list@gnome.org,
the website is http://www.gnome.org/projects/NetworkManager/

I believe this list is about the kernel part of wireless support.  If
you track the issue to the kernel, then please post here.  Don't forget
the kernel messages and more details about the kernel.

If you want a basic connection with WEP, you can try to use iwconfig.
Please make sure to set the channel, the AP (BSSID) and the ESSID.

You can also run wpa_supplicant from the command line.  wpa_supplicant
would find the AP for you.

-- 
Regards,
Pavel Roskin


_______________________________________________
wireless mailing list
wireless@lists.tuxdriver.org
http://lists.tuxdriver.org/mailman/listinfo/wireless
