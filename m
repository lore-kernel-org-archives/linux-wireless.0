Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56115 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1CVJ7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 05:59:48 -0400
Received: by yxs7 with SMTP id 7so2791297yxs.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 02:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300781267-4047-1-git-send-email-arik@wizery.com>
References: <1300781267-4047-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 22 Mar 2011 11:59:32 +0200
Message-ID: <AANLkTikKc+yeJ4Gxhh8DtJmib=C3caF--weCpfbaRy5Q@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: configure channel/band while FW is off
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, "Zaphir, Ruthy" <ruthyz@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2011 at 10:07, Arik Nemtsov <arik@wizery.com> wrote:
> Initialize the channel and band from mac80211 conf even when the FW is
> not yet loaded. This mitigates a bug in AP-mode where the channel was
> never changed from its initial setting after FW boot and was therefore
> never configured to FW.

Special thanks to Ruthy Zaphir <ruthyz@ti.com> for debugging this one.

Arik
