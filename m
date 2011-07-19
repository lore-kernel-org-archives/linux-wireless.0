Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46445 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1GSE0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 00:26:51 -0400
Message-ID: <4E250784.3020005@qca.qualcomm.com> (sfid-20110719_062655_301711_45731D4C)
Date: Tue, 19 Jul 2011 07:26:44 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <ali@internetdog.org>
CC: <linux-wireless@vger.kernel.org>, <joe@perches.com>,
	<devel@linuxdriverproject.org>, <gregkh@suse.de>,
	<error27@gmail.com>
Subject: Re: [PATCH v2 00/23] ath6kl cleaned up driver
References: <20110717101844.18367.44984.stgit@localhost6.localdomain6> <20110719042119.GA2988@internetdog.org>
In-Reply-To: <20110719042119.GA2988@internetdog.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ali,

On 07/19/2011 07:21 AM, Ali Bahar wrote:
>
> On Sun, Jul 17, 2011 at 01:20:07PM +0300, Kalle Valo wrote:
>> Hello,
>>
>> last May we started working on cleaning up ath6kl driver which is
>> currently in staging. The work has happened in a separate
>> ath6kl-cleanup tree:
>>
>> http://git.kernel.org/?p=linux/kernel/git/kvalo/ath6kl-cleanup.git;a=summary
>>
>> After over 1100 (!) patches we have now reached a state where I would
>> like to start discussing about pushing the driver to the wireless
>> trees and replacing the staging driver.
> 
>> Please review and comment. John, please consider taking this driver to
>> wireless-testing.
> 
> you seem to have not CCed John on this.

Good point, I missed him but I'm sure he got it anyway through
linux-wireless mailing list. Next time I'll CC him.

Kalle
