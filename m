Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:54196 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760631AbbA3Ko1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 05:44:27 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so26142423wgh.6
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 02:44:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422607287-12289-3-git-send-email-michal.kazior@tieto.com>
References: <1422607287-12289-1-git-send-email-michal.kazior@tieto.com>
	<1422607287-12289-3-git-send-email-michal.kazior@tieto.com>
Date: Fri, 30 Jan 2015 11:44:26 +0100
Message-ID: <CA+BoTQmnwezzOERV460ZXi8XxH9bFKeYJRXMGX5N0OKoV5a+iQ@mail.gmail.com> (sfid-20150130_114435_577112_3BE7822B)
Subject: Re: [PATCH 2/7] ath10k: implement chanctx API
From: Michal Kazior <michal.kazior@tieto.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 09:41, Michal Kazior <michal.kazior@tieto.com> wrote:
> The chanctx API will allow ath10k to support
> multi-channel operation.
[...]

Oh snap. I just rebased to latest master and Yanbo's patch for 2G VHT
makes this patch null deref on assoc. I'll respin a v2 later.


Michał
