Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:60935 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2GCAS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 20:18:26 -0400
Received: by ghrr11 with SMTP id r11so4721630ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 17:18:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341238934-30855-5-git-send-email-ozancag@gmail.com>
References: <1341238934-30855-1-git-send-email-ozancag@gmail.com> <1341238934-30855-5-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 2 Jul 2012 17:18:04 -0700
Message-ID: <CAB=NE6WHUC5bXx4Vj4vQFavzZDrdwztBC3QKvjLcUMsMysLGEA@mail.gmail.com> (sfid-20120703_021830_689996_77A165B0)
Subject: Re: [PATCH 5/5] compat: Backport DIV_ROUND_UP_DLL macro
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 2, 2012 at 7:22 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> This backports:
>
> commit 36a26c69b4c70396ef569c3452690fba0c1dec08
> Author: Nicholas Bellinger <nab@linux-iscsi.org>
> Date:   Tue Jul 26 00:35:26 2011 -0700
>
>     kernel.h: Add DIV_ROUND_UP_ULL and DIV_ROUND_UP_SECTOR_T macro usage
>
> Trying kernel  3.4.0-030400-generic [OK]
> Trying kernel  3.3.7-030307-generic [OK]
> Trying kernel  3.2.2-030202-generic [OK]
> Trying kernel  3.1.10-030110-generic [OK]
> Trying kernel  3.0.18-030018-generic [OK]
> Trying kernel  2.6.39-02063904-generic [OK]
> Trying kernel  2.6.38-02063808-generic [OK]
> Trying kernel  2.6.37-02063706-generic [OK]
> Trying kernel  2.6.36-02063604-generic [OK]
> Trying kernel  2.6.35-02063512-generic [OK]
> Trying kernel  2.6.34-02063410-generic [OK]
> Trying kernel  2.6.33-02063305-generic [OK]
> Trying kernel  2.6.32-02063255-generic [OK]
> Trying kernel  2.6.31-02063113-generic [OK]
> Trying kernel  2.6.30-02063010-generic [OK]
> Trying kernel  2.6.29-02062906-generic [OK]
> Trying kernel  2.6.28-02062810-generic [OK]
> Trying kernel  2.6.27-020627-generic [OK]
> Trying kernel  2.6.26-020626-generic [OK]
> Trying kernel  2.6.25-020625-generic [OK]
> Trying kernel  2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed all, thanks!

  Luis
