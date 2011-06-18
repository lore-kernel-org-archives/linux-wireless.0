Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45145 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab1FRIDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 04:03:12 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 0/6] NFC subsystem
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Sat, 18 Jun 2011 10:03:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	<linux-wireless@vger.kernel.org>, <marcio.macedo@openbossa.org>,
	<aloisio.almeida@openbossa.org>, <sameo@linux.intel.com>,
	<Waldemar.Rymarkiewicz@tieto.com>
In-Reply-To: <20110617164510.GA6820@tuxdriver.com>
 (sfid-20110617_190155_298688_6B1DFAB0)
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
 <20110617164510.GA6820@tuxdriver.com> (sfid-20110617_190155_298688_6B1DFAB0)
Message-ID: <38f85e7ce64d0e55f86eb9104ec41364@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 17 Jun 2011 12:45:11 -0400, John W. Linville wrote:
> On Thu, Jun 02, 2011 at 06:46:04PM -0300, Lauro Ramos Venancio wrote:
>> This series of patches implements the first part of the Near Field
>> Communication (NFC) subsystem.
>
> Will you be submitting a new series to account for the comments from
> Johannes and others?

Yeah, but they found some issues with the dump consistency stuff that 
tgr and I would like to solve generically (he was aware of them before); 
I'm hoping I can do that quickly next week and then this can rely on it 
instead of re-implementing it first.

johannes
