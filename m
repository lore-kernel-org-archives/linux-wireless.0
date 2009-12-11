Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:10266 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811AbZLKSHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 13:07:54 -0500
Received: by ey-out-2122.google.com with SMTP id d26so367004eyd.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Dec 2009 10:08:00 -0800 (PST)
Message-ID: <4B228A7B.8000307@gmail.com>
Date: Fri, 11 Dec 2009 19:07:55 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] zd1211rw: improve ejecting of fake CDROM
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Seyfried <seife@sphairon.com> wrote:

> The zd1211rw always assumed that the storage device is at endpoint 1,
> but there are devices (Spairon Homelink 1202) that are at endpoint 0.
> Try both, starting with 1 to make sure to not break existing setups.

should eject_installer code go into usb storage infrastructure
unusual_devs.h initializers.[ch] ?
