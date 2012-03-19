Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38213 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965074Ab2CSWmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 18:42:07 -0400
Received: by eaaq12 with SMTP id q12so2830791eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 15:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332164662-18232-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1332164662-18232-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 20 Mar 2012 09:41:45 +1100
Message-ID: <CAGRGNgXbS4ZO_vZA3o0jgovL=_2_GxxGP8iE4snnzSdEztsyqA@mail.gmail.com> (sfid-20120319_234220_163060_7D0D3519)
Subject: Re: [PATCH] e1000: Silence sparse warnings by correcting type
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

Stupid question: Why have you sent this to linux-wireless?

Thanks,

Julian Calaby

On Tue, Mar 20, 2012 at 00:44, Andrei Emeltchenko
<Andrei.Emeltchenko.news@gmail.com> wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>
> Silence sparse warnings shown below:
> ...
> drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
>        cast to restricted __le64
> drivers/net/ethernet/intel/e1000/e1000_main.c:3435:17: warning:
>        cast to restricted __le64
> ...
>
> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
