Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3968 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2DYGil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 02:38:41 -0400
Message-ID: <4F979BEC.1020204@qca.qualcomm.com> (sfid-20120425_083845_275547_0134A0C4)
Date: Wed, 25 Apr 2012 09:38:36 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: check for sband existence when creating scan
 cmd
References: <1335297041-4328-1-git-send-email-c_tpeder@qca.qualcomm.com>
In-Reply-To: <1335297041-4328-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 10:50 PM, Thomas Pedersen wrote:
> The patch "ath6kl: support fw reporting phy capabilities" gave the
> firmware the ability to disable certain wiphy supported bands. Check if
> this is the case in ath6kl_wmi_beginscan_cmd to avoid dereferencing a
> NULL pointer.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>

Thanks, applied with changes. I really didn't like mixing code and
declarations so I changed the code a bit and added few empty lines for
readibility. There shouldn't be any functional changes but please do
check my changes.

Kalle
