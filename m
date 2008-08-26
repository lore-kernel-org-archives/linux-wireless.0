Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:17571 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbYHZUGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 16:06:24 -0400
Received: by nf-out-0910.google.com with SMTP id d3so998589nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 13:06:23 -0700 (PDT)
Message-ID: <1ba2fa240808261306s58ffe82dyf8d217bfa37c06d5@mail.gmail.com> (sfid-20080826_220629_551987_9ACD6575)
Date: Tue, 26 Aug 2008 23:06:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.27 2/2] iwlwifi: fix 64bit platform firmware loading
Cc: linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1219718071-13587-2-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1219718071-13587-1-git-send-email-yi.zhu@intel.com>
	 <1219718071-13587-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 26, 2008 at 5:34 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
>
> This patch fixes loading firmware from memory above 34bit.

         ^^ - John,  please fix this little typo when merging
Thanks
Tomas
