Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:44546 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab0A2RLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 12:11:13 -0500
Received: by pxi12 with SMTP id 12so1723751pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2010 09:11:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100129112651.GA1862@user-laptop>
References: <20100129112651.GA1862@user-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 Jan 2010 09:10:52 -0800
Message-ID: <43e72e891001290910odd98f15l141209817dd7d0d6@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Handle full sleep in ps_restore.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2010 at 3:26 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> IDLE PS (Full Sleep) doesn't work when ifconfig up
> is done during Idle unassociated state.
> Fix this by restoring FULL SLEEP in ps_restore if CONF_IDLE
> is set.

Is this is stable fix too?

  Luis
