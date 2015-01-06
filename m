Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:36792 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbAFSEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 13:04:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ipw2x00: ipw2200.c:  Remove unused function
References: <1419078599-31118-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 06 Jan 2015 20:04:41 +0200
In-Reply-To: <1419078599-31118-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 20 Dec 2014 13:29:59 +0100")
Message-ID: <8761cjzsxy.fsf@kamboji.qca.qualcomm.com> (sfid-20150106_190631_112894_CA617D60)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> Remove the function ipw_alive() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Please improve the patch title and make it more unique like:

ipw2200: remove unused ipw_alive()

-- 
Kalle Valo
