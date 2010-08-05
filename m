Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58816 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558Ab0HENyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 09:54:53 -0400
Received: by qwh6 with SMTP id 6so3957041qwh.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 06:54:52 -0700 (PDT)
Message-ID: <4C5AC2B1.7060007@lwfinger.net>
Date: Thu, 05 Aug 2010 08:54:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arthur Moreira <arthur.moreira@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: bdm 4353 802.11n monitor mode you can?
References: <AANLkTi=Q7FXWnH9dyH3mPX7G+JDBNVb0NWuYjqd_VN2F@mail.gmail.com>
In-Reply-To: <AANLkTi=Q7FXWnH9dyH3mPX7G+JDBNVb0NWuYjqd_VN2F@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2010 06:57 AM, Arthur Moreira wrote:
> Someone can put the broadcom card 802.11n bcmw 4353 in monitor mode?

The Broadcom wl hybrid driver does not support monitor mode, and that is the
only driver for 802.11n Broadcom chips. Until we finish getting b43 running on
such devices, you will not have that option.

Complain to Broadcom.

Larry
