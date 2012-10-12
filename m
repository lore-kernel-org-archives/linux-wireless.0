Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46633 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab2JLM13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 08:27:29 -0400
To: Pandiyarajan Pitchaimuthu <c_ppitch@qti.qualcomm.com>
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Message-ID: <50780CAC.3030808@qca.qualcomm.com> (sfid-20121012_142732_745706_A28E2B14)
Date: Fri, 12 Oct 2012 15:27:24 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Subject: Re: [PATCH V2] ath6kl: Array index out of bounds check
References: <1348238506-9691-1-git-send-email-c_ppitch@qca.qualcomm.com>
In-Reply-To: <1348238506-9691-1-git-send-email-c_ppitch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 05:41 PM, Pandiyarajan Pitchaimuthu wrote:
> The variable assigned_ep can be assigned value of -1 and is never
> checked if it equals -1. So the endpoint array can have -1  as the index
> value and can be out of bounds.
> 
> The value of assigned_ep is checked for -1 and is ensured that the
> endpoint array doesn't go out of bounds.
> 
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>

Thanks, applied.

Kalle
