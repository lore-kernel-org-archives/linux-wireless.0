Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:43916 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbYIRUXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:23:24 -0400
Received: by fg-out-1718.google.com with SMTP id 19so324353fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 13:23:23 -0700 (PDT)
Message-ID: <1ba2fa240809181323n2fba2c93j7e884a437efbfe58@mail.gmail.com> (sfid-20080918_222327_335367_42F54397)
Date: Thu, 18 Sep 2008 23:23:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Gordon, Charles" <Charles.Gordon@digi.com>
Subject: Re: What is the state of 802.11h support?
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <8DCC153EAFE67A4B990A840E829F704B718874D96D@mtk-sms-exch01.digi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
