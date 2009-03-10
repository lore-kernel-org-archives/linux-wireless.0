Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:7524 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZCJHCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:02:32 -0400
Received: by fg-out-1718.google.com with SMTP id 16so913701fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 00:02:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
References: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com>
Date: Tue, 10 Mar 2009 07:02:29 +0000
Message-ID: <3ace41890903100002m341a15b6mb6a18226dff84212@mail.gmail.com> (sfid-20090310_080235_505715_853B0BA6)
Subject: Re: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, dsd@gentoo.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 10, 2009 at 2:10 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> The __nocast attribute is used to shut sparse up but we
> don't need it, lets just use u16 directly.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>
> Can someone test this for me? The zd1211rw device seems to require
> a bit more tweaks to work so not sure ifs the patch, it wasn't working
> with zd1211rw anyway. We will release another update to the vendor driver
> to help with addition of new device support.

Am I reading this correctly - an update to the vendor driver?

I am using a somewhat patched vendor driver (22.0.0.0) as my access
point, as AP mode in the rw driver isn't in sight yet.
Am volunteering as a guinea pig if there is an update.

v 22.0.0.0 was 2.6.24(2.6.26?) era and I updated it to 2.6.28.x and
posted the patch to sf zd1211 ml; there is another netdev_priv()
update for 2.6.29+ which is sitting in my hard disc and will go to my
rather low-spec AP machine when I next rebuild the kernel...
