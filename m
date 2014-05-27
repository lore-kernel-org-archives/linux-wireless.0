Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40368 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbaE0Oqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:46:49 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 4/7] wil6210: improve debug for WMI receive
Date: Tue, 27 May 2014 17:46:45 +0300
Message-ID: <1417278.VSQeiOskQO@lx-wigig-72> (sfid-20140527_164652_721601_3E66D4FA)
In-Reply-To: <1401200106.20587.0.camel@joe-AO725>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1835954.xHumgOahYl@lx-wigig-72> <1401200106.20587.0.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, May 27, 2014 07:15:06 AM Joe Perches wrote:
> Then is it an error?
> Maybe use dev_notice instead.

Well, it is not an error, but rather some indication of the
firmware issue. I tend to agree with you and demote it
to the 'debug' category; I use dynamic printk for this and it is
convenient enough for both used and developer.

So, I'll resubmit shortly

John: can you apply other patches? I verified there are no
conflicts if you drop this one. Or, do you want me to re-submit
whole set? What works better for you?

Thanks, Vladimir
