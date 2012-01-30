Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:51243 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751882Ab2A3Hcd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 02:32:33 -0500
Received: by mail-ww0-f48.google.com with SMTP id gn7so3089526wgb.5
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 23:32:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201261927.17754.david.goodenough@btconnect.com>
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
	<201201261927.17754.david.goodenough@btconnect.com>
Date: Mon, 30 Jan 2012 09:32:32 +0200
Message-ID: <CAK80WHZr484-9Ap2hxm1S59rBAh8z2hHOZ3c5w+cNLSakK_Cgg@mail.gmail.com> (sfid-20120130_083237_089950_D823E12C)
Subject: Re: [RFC 0/7] hostap: add DFS master ability
From: "Goldenshtein, Victor" <victorg@ti.com>
To: David Goodenough <david.goodenough@btconnect.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 26, 2012 at 9:27 PM, David Goodenough
<david.goodenough@btconnect.com> wrote:
> As I understand it hostapd is not involved in mesh (802.11s) networks,
> so how does this integrate there?  As I understand it 802.11s is entirely
> done in the kernel.
>

At this point we don't have any plans to extend DFS support to mesh networks.

-- 
Thanks,
Victor.
