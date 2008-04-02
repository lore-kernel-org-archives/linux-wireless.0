Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:62001 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbYDBTud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 15:50:33 -0400
Received: by el-out-1112.google.com with SMTP id v27so1395245ele.17
        for <linux-wireless@vger.kernel.org>; Wed, 02 Apr 2008 12:50:32 -0700 (PDT)
Message-ID: <1ba2fa240804021250t4d0f3e12g201f1af253dea838@mail.gmail.com> (sfid-20080402_205040_215182_CB4FF6C1)
Date: Wed, 2 Apr 2008 22:50:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jason Riedy" <jason@acm.org>
Subject: Re: [PATCH] Remove most references to iwl4965-only features from iwl3945.
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <87bq4shix3.fsf@sparse.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <87bq4shix3.fsf@sparse.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  -       /* HW RF KILL switch toggled (4965 only) */
>  +       /* HW RF KILL switch toggled */
>         if (inta & CSR_INT_BIT_RF_KILL) {
>                 int hw_rf_kill = 0;
>                 if (!(iwl3945_read32(priv, CSR_GP_CNTRL) &

This one is not supported in 3945 for real.

Tomas
