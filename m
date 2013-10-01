Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:36381 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3JAAnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 20:43:10 -0400
Received: by mail-qc0-f177.google.com with SMTP id x12so4198996qcv.36
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 17:43:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+=D8wmgsBimQhSYDqWbuzwM544YrX1Gj9gsmftQUHoD+QYeZw@mail.gmail.com>
References: <CA+=D8wmgsBimQhSYDqWbuzwM544YrX1Gj9gsmftQUHoD+QYeZw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Oct 2013 10:42:49 +1000
Message-ID: <CAGRGNgXy37rXWou4sWDfUe+UhpXqxLanhSaH0MPNw_oV+mYbOA@mail.gmail.com> (sfid-20131001_024321_693466_F1CB52EF)
Subject: Re: Idea: wifi-over-ethernet (bear with me)
To: Erik Elmore <erik@erikelmore.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Erik,

On Tue, Oct 1, 2013 at 5:40 AM, Erik Elmore <erik@erikelmore.com> wrote:
> Hello, linux-wireless.  I have an idea that I'd like to get some
> feedback from you all.  I admit this idea is weird/flawed/broken and
> seemingly useless, but I do have a practical application in mind, so
> please hear me out.
>
> Imagine two physical locations, site 1 and 2, that are well outside of
> normal wifi range of each other.  Each site has a device that listens
> for a subset of wifi frames and then sends them over a distribution
> network to its counterpart at the other site.  Each device will also
> re-transmit frames received via the distribution network.  Let's call
> these devices listener1 and listener2.
>
> Each site also contains one client device that wants to form an ad-hoc
> network with the one in the other site.  Assuming that listener1 and
> listener2 are configured to forward frames having a TA belonging to
> the client device in their site, is it feasible for these devices to
> form an ad-hoc network with the help of the listener devices?

Firstly, what's the big plan? - I can't see any useful reason to
"tunnel" ad-hoc networks between two points, assuming that you did
have all the hardware and software working properly, what is the end
goal here, why do you need to have two devices at remote locations
form an ad-hoc network with each other? What goal do you have in mind
that wouldn't work with a normal managed network?

Just so you know, this sort of setup is almost painfully easy to
achieve if you use managed networks. - You could simply have a VPN or
tunnelling setup of some type between the two access points and have
that bridged into the wireless network. This would be 100% transparent
as far as clients on the network would be concerned. My previous job
had a network that worked somewhat like that with VPNs connecting
three offices with WiFi, two data centres and several remote clients
into a "single" big network.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
