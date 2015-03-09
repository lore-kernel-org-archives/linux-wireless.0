Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 14.mo6.mail-out.ovh.net ([46.105.56.113]:43784 "EHLO
	14.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbbCIKjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 06:39:39 -0400
Received: from mail187.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id 6A205FF926E
	for <linux-wireless@vger.kernel.org>; Mon,  9 Mar 2015 11:30:31 +0100 (CET)
Message-ID: <54FD755A.3010300@effinnov.com> (sfid-20150309_113943_857235_7695AA6C)
Date: Mon, 09 Mar 2015 11:26:34 +0100
From: =?windows-1252?Q?Cl=E9ment_Perrochaud?=
	<clement.perrochaud@effinnov.com>
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: linux-nfc@lists.01.org,
	=?windows-1252?Q?Cl=E9ment_Perrochaud?=
	<clement.perrochaud@nxp.com>, sunil.jogi@nxp.com,
	jerome.pele@nxp.com, Charles.Gorand-Effinnov@nxp.com,
	lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	davem@davemloft.net, grant.likely@linaro.org, lefrique@marvell.com,
	christophe.ricard@gmail.com, cuissard@marvell.com,
	bzhao@marvell.com, hirent@marvell.com, akarwar@marvell.com,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] NFC: nci: Add FWDL support
References: <1421940460-14049-1-git-send-email-clement.perrochaud@effinnov.com> <1421940460-14049-2-git-send-email-clement.perrochaud@effinnov.com> <20150129232859.GA20998@ribalta.ger.corp.intel.com>
In-Reply-To: <20150129232859.GA20998@ribalta.ger.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2015 12:28 AM, Samuel Ortiz wrote:
> - It really is not obvious that FWDL actually means firmware download
> - A small commit message explaining why you need this (Mostly for the
>   NXP chipset for now) would be nice.

Hi Samuel,

Thank you for all your comments, I just sent an improved version of the
patches taking them into account.

Regards,

-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com
