Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:42250 "EHLO
	homiemail-a64.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755522Ab3JADjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 23:39:19 -0400
Received: from homiemail-a64.g.dreamhost.com (localhost [127.0.0.1])
	by homiemail-a64.g.dreamhost.com (Postfix) with ESMTP id ADF0D43807C
	for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 20:39:18 -0700 (PDT)
Received: from mail-pa0-f42.google.com (mail-pa0-f42.google.com [209.85.220.42])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: erik@erikelmore.com)
	by homiemail-a64.g.dreamhost.com (Postfix) with ESMTPSA id 9CB22438079
	for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 20:39:18 -0700 (PDT)
Received: by mail-pa0-f42.google.com with SMTP id lj1so6819698pab.29
        for <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 20:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXy37rXWou4sWDfUe+UhpXqxLanhSaH0MPNw_oV+mYbOA@mail.gmail.com>
References: <CA+=D8wmgsBimQhSYDqWbuzwM544YrX1Gj9gsmftQUHoD+QYeZw@mail.gmail.com>
	<CAGRGNgXy37rXWou4sWDfUe+UhpXqxLanhSaH0MPNw_oV+mYbOA@mail.gmail.com>
Date: Mon, 30 Sep 2013 23:39:18 -0400
Message-ID: <CA+=D8wnh59iQfmk8nDjnEZUBHpiZBXFBWwtGu_y_Ldy1b06Jnw@mail.gmail.com> (sfid-20131001_053922_477885_4E4DA451)
Subject: Re: Idea: wifi-over-ethernet (bear with me)
From: Erik Elmore <erik@erikelmore.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are a few big ideas, but the one big idea that got me started on
this line of thought was to make it possible for devices that only
support ad-hoc networks to function over great distances.

On Mon, Sep 30, 2013 at 8:42 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Erik,
>
> On Tue, Oct 1, 2013 at 5:40 AM, Erik Elmore <erik@erikelmore.com> wrote:
>> Hello, linux-wireless.  I have an idea that I'd like to get some
>> feedback from you all.  I admit this idea is weird/flawed/broken and
>> seemingly useless, but I do have a practical application in mind, so
>> please hear me out.
>>
>> Imagine two physical locations, site 1 and 2, that are well outside of
>> normal wifi range of each other.  Each site has a device that listens
>> for a subset of wifi frames and then sends them over a distribution
>> network to its counterpart at the other site.  Each device will also
>> re-transmit frames received via the distribution network.  Let's call
>> these devices listener1 and listener2.
>>
>> Each site also contains one client device that wants to form an ad-hoc
>> network with the one in the other site.  Assuming that listener1 and
>> listener2 are configured to forward frames having a TA belonging to
>> the client device in their site, is it feasible for these devices to
>> form an ad-hoc network with the help of the listener devices?
>
> Firstly, what's the big plan? - I can't see any useful reason to
> "tunnel" ad-hoc networks between two points, assuming that you did
> have all the hardware and software working properly, what is the end
> goal here, why do you need to have two devices at remote locations
> form an ad-hoc network with each other? What goal do you have in mind
> that wouldn't work with a normal managed network?
>
> Just so you know, this sort of setup is almost painfully easy to
> achieve if you use managed networks. - You could simply have a VPN or
> tunnelling setup of some type between the two access points and have
> that bridged into the wireless network. This would be 100% transparent
> as far as clients on the network would be concerned. My previous job
> had a network that worked somewhat like that with VPNs connecting
> three offices with WiFi, two data centres and several remote clients
> into a "single" big network.
>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
