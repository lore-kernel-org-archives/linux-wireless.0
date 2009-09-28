Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:39995 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZI1U2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 16:28:53 -0400
Received: by pxi32 with SMTP id 32so3745559pxi.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 13:28:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909271541.58448.sturmflut@lieberbiber.de>
References: <200909271541.58448.sturmflut@lieberbiber.de>
Date: Mon, 28 Sep 2009 13:28:57 -0700
Message-ID: <45e8e6c40909281328g59113e35j97729718766e0dbb@mail.gmail.com>
Subject: Re: Unable to create an 802.11s mesh using compat-wireless-2009-09-27
From: Andrey Yurovsky <andrey@cozybit.com>
To: Simon Raffeiner <sturmflut@lieberbiber.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2009 at 6:41 AM, Simon Raffeiner
<sturmflut@lieberbiber.de> wrote:
> and falls back to "Managed" after about five seconds:

Is there an application like NetworkManager running?  If so, please
kill it before proceeding.  Also it's not useful/needed to run
"iwconfig", it doesn't understand mesh interfaces.  Please only use
iw.

  -Andrey
