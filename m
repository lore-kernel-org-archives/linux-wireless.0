Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60160 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0HJQwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 12:52:09 -0400
Received: by pvg2 with SMTP id 2so1272737pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 09:52:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Aug 2010 09:51:48 -0700
Message-ID: <AANLkTinJtJGQCgpWCu5t+EF7bEvXR3cQG7oHuagrjd1a@mail.gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 0/1] fix for 2.6.35
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 9, 2010 at 10:57 AM, Wey-Yi Guy <wey-yi.w.guy@intel.com> wrote:
> This patch required for 2.6.35 to fix 5GHz association problem. Without this,
> iwlagn device will have issue connecting to 11a AP
>
> Johannes Berg (1):
>  iwlagn: fix rts cts protection

This patch has an awesome commit log entry and describes issues with
the current RTS mechanism and improvements made on the patch for
different scenarios but in no way talks about issues with association
with 5 GHz APs. Can you clarify in the commit log how it cures issues
with 5 GHz, if that is indeed an intended fix for it?

  Luis
