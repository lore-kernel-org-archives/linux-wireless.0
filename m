Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail29.messagelabs.com ([216.82.249.147]:24559 "EHLO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYIRUzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:55:18 -0400
From: "Gordon, Charles" <Charles.Gordon@digi.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 18 Sep 2008 15:53:40 -0500
Subject: RE: What is the state of 802.11h support?
Message-ID: <8DCC153EAFE67A4B990A840E829F704B718873D822@mtk-sms-exch01.digi.com> (sfid-20080918_225523_128621_76CDE8FB)
References: <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>,<1ba2fa240809181323n2fba2c93j7e884a437efbfe58@mail.gmail.com>
In-Reply-To: <1ba2fa240809181323n2fba2c93j7e884a437efbfe58@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm looking for the stuff which is required to implement a client device.  That is a device which does not implement radar detection.

Is there a schedule for when this stuff will be integrated into the kernel?

Charles

________________________________________
From: Tomas Winkler [tomasw@gmail.com]
Sent: Thursday, September 18, 2008 4:23 PM
To: Gordon, Charles
Cc: linux-wireless@vger.kernel.org
Subject: Re: What is the state of 802.11h support?

On Thu, Sep 18, 2008 at 5:31 PM, Gordon, Charles
<Charles.Gordon@digi.com> wrote:
> Can someone tell me how much of 802.11h is supported by Linux?  What is the plan for completing it enough so that it implements a client which complies with the specification?
>
> What needs to be implemented in the wireless NIC driver to support 802.11h?  My company is working on a wireless NIC driver for Linux.
>
What part of 11h are you looking for. We have pending implementation
for everything that is under must requirement for BSS mode. Radar
detection is not implemented.

Tomas
