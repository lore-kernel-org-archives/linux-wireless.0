Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40458 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab2BHFX6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 00:23:58 -0500
Received: by obcva7 with SMTP id va7so299507obc.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2012 21:23:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328677765-21971-1-git-send-email-mcgrof@frijolero.org>
References: <1328677765-21971-1-git-send-email-mcgrof@frijolero.org>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 7 Feb 2012 21:23:38 -0800
Message-ID: <CAPjQAd9ayG1kcpzx9pimy6=g6EYS1VvJ=q8JMA7AibHhBV-3Gg@mail.gmail.com> (sfid-20120208_062403_002667_01FDC153)
Subject: Re: [PATCH] mac80211: rename mesh static path_lookup()
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 7, 2012 at 9:09 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> If you want to use mesh support from mac80211 on a recent
> kernel on 2.6.24 you'll run into a name clash when compiling
> against include/linux/namei.h, so rename this routine.
>
> /home/mcgrof/tmp/compat-wireless-3.2.5-1/net/mac80211/mesh_pathtbl.c: At top level:
> /home/mcgrof/tmp/compat-wireless-3.2.5-1/net/mac80211/mesh_pathtbl.c:342:26: error: conflicting types for ‘path_lookup’
> include/linux/namei.h:71:12: note: previous declaration of ‘path_lookup’ was here
>
> Although this could sit as a separate patch in compat-wireless it seems
> best to just merge upstream.
>
> Cc: Javier Cardona <javier@cozybit.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
Acked-by: Javier Cardona <javier@cozybit.com>
