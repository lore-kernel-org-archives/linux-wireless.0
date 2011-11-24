Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29507 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1KXMcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 07:32:22 -0500
Message-ID: <4ECE394D.4000603@qca.qualcomm.com> (sfid-20111124_133225_817435_FCD3A82A)
Date: Thu, 24 Nov 2011 14:32:13 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: remove unused sc_params from struct ath6kl
References: <20111123182154.25200.78078.stgit@localhost6.localdomain6>
In-Reply-To: <20111123182154.25200.78078.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/23/2011 08:21 PM, Kalle Valo wrote:
> It was only initialised but not used anywhere. Also remove two defines
> which ended up unused after this change.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
