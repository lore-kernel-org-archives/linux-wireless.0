Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40101 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbbJZVvA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 17:51:00 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1ZqpfO-0000mC-6c
	for linux-wireless@vger.kernel.org; Mon, 26 Oct 2015 22:50:58 +0100
Received: from gas45-3-82-244-252-119.fbx.proxad.net ([82.244.252.119])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 22:50:58 +0100
Received: from j.cubizolles by gas45-3-82-244-252-119.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 22:50:58 +0100
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: Re: mwifiex problem: incompatible network settings
Date: Mon, 26 Oct 2015 22:50:51 +0100
Message-ID: <87twpd8fk4.fsf@free.fr> (sfid-20151026_225104_311793_7D14D246)
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Mon, 2015-10-26 at 16:51 +0100, Julien Cubizolles wrote:
>> I can't connect anymore to my home wifi since upgrading my machine from
>> Ubuntu 15.04 to Ubuntuy 15.10. I was previously running kernel 4.3.0-rc2
>> from kernel.org without any problem. After the upgrade, and with the
>> same kernel, I couldn't connect anymore. I built 4.3.0-rc7, and the
>> problem remains. However, I can connect to the wifi access point from my
>> Android phone.
>> 
>> Here are the relevant lines from syslog. Let me know if you need more
>> information.
>
> The AP uses WPA, but the driver has been told that WPA is disabled.  Are
> you using wpa_supplicant (or NetworkManager, or something else?) to
> control the WiFi, and if so what version is it?

Yes, I'm using NetworkManager, version 1.0.4-ubuntu5, and I'm guessing
it's using wpa_supplicant. I deleted the configuration for this network
and created it again. The network is configured for WPA in
NetworkManager but I still get the same error message.

Thanks for your help.

