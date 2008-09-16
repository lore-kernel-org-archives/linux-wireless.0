Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:43331 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYIPJah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:30:37 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1650988fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 02:30:36 -0700 (PDT)
Message-ID: <1ba2fa240809160230l59ae1be1m905a13f1f6d5658e@mail.gmail.com> (sfid-20080916_113042_778643_5EF27C27)
Date: Tue, 16 Sep 2008 12:30:35 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH 1/2] iwlwifi: don't delay scan in IBSS mode
Cc: linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221544864-9494-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +                       /* we have just associated, don't start scan too early
> +                        * leave time for EAPOL echange complete
> +                        */
John please fix this little typo when applying (echange complete ->
exchange to complete )
Thanks
Tomas
