Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:6976 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763869AbZC0CVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 22:21:10 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1028172fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 19:21:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b49006ab0903261027y1b7bf7a1ob783b79d1960b48f@mail.gmail.com>
References: <b49006ab0903260414xad13bd5y370a47020348c66f@mail.gmail.com>
	 <b49006ab0903260822r35417242qbdc6889543de7072@mail.gmail.com>
	 <alpine.DEB.2.00.0903261752470.11410@aurora.sdinet.de>
	 <43e72e890903261014j7d050d44wf72ab2c25bc8d625@mail.gmail.com>
	 <b49006ab0903261027y1b7bf7a1ob783b79d1960b48f@mail.gmail.com>
Date: Fri, 27 Mar 2009 02:21:07 +0000
Message-ID: <3ace41890903261921j5fcd72dfi41ecec6316ef1975@mail.gmail.com> (sfid-20090327_032132_042839_F96D9C26)
Subject: Re: Driver Support Linux 2.4.26 zd1211
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Paco <eyes2k5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 5:27 PM, Paco <eyes2k5@gmail.com> wrote:
> Yes, I know that with 2.6.x is working but the embedded system I'm
> working with only support 2.4.x so... I need to fix the driver to this
> version. Upgrade the kernel is not an option.

You could look for the vendor driver (ZD1211LnxDrv_*) which seems to
have some support for 2.4.x
If you do make any enhancement/bug-fixes, please post. The last is
ZD1211LnxDrv_2_22_0_0 AFAIK.
