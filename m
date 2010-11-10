Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34683 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab0KJR0Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 12:26:16 -0500
Received: by iwn10 with SMTP id 10so1045412iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 09:26:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289391829-8577-5-git-send-email-vnatarajan@atheros.com>
References: <1289391829-8577-1-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-2-git-send-email-vnatarajan@atheros.com> <1289391829-8577-3-git-send-email-vnatarajan@atheros.com>
 <1289391829-8577-4-git-send-email-vnatarajan@atheros.com> <1289391829-8577-5-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Nov 2010 09:25:55 -0800
Message-ID: <AANLkTik6T9bSNUrQB6+Ob75+B3070MbZagYh_0MRbB+U@mail.gmail.com>
Subject: Re: [RFC 5/5] ath9k_hw: Add support for Tx beamforming.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 4:23 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> Initialize Tx beamforming capabilities, related registers and set
> descriptors for sounding frames.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Hardware patch for ath9k_hw should go first otherwise would you not
get a compile issue?

  Luis
