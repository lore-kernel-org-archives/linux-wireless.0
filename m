Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:38594 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab2F1SwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 14:52:01 -0400
Received: by obbuo13 with SMTP id uo13so3386080obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 11:52:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340618912-6845-1-git-send-email-ozancag@gmail.com>
References: <1340618912-6845-1-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 28 Jun 2012 11:51:39 -0700
Message-ID: <CAB=NE6W4HQmbMOissrmydQ11q_hw=XCR-g_SsVtc9BNRuS41ig@mail.gmail.com> (sfid-20120628_205204_614839_AB52F52E)
Subject: Re: [PATCH v3] compat: Define include guard for vga_switcheroo.h
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 25, 2012 at 3:08 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> The check is missing in upstream. Patch sent but until this gets
> merged, define it in compat tree for fixing compat-drm builds.
>
> Trying kernel  3.4.0-030400-generic [OK]
> Trying kernel  3.3.7-030307-generic [OK]
> Trying kernel  3.2.2-030202-generic [OK]
> Trying kernel  3.1.10-030110-generic [OK]
> Trying kernel  3.0.18-030018-generic [OK]
> Trying kernel  2.6.39-02063904-generic [OK]
> Trying kernel  2.6.38-02063808-generic [OK]
> Trying kernel  2.6.37-02063706-generic [OK]
> Trying kernel  2.6.36-02063604-generic [OK]
> Trying kernel  2.6.35-02063512-generic [OK]
> Trying kernel  2.6.34-02063410-generic [OK]
> Trying kernel  2.6.33-02063305-generic [OK]
> Trying kernel  2.6.32-02063255-generic [OK]
> Trying kernel  2.6.31-02063113-generic [OK]
> Trying kernel  2.6.30-02063010-generic [OK]
> Trying kernel  2.6.29-02062906-generic [OK]
> Trying kernel  2.6.28-02062810-generic [OK]
> Trying kernel  2.6.27-020627-generic [OK]
> Trying kernel  2.6.26-020626-generic [OK]
> Trying kernel  2.6.25-020625-generic [OK]
> Trying kernel  2.6.24-020624-generic [OK]
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

Applied and pushed, thanks!

  Luis
