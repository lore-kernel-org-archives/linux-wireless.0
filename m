Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40764 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbBJH1C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 02:27:02 -0500
Date: Tue, 10 Feb 2015 12:56:45 +0530
From: Rajkumar <rmanohar@qti.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: Increase copy engine entries for rx wmi
Message-ID: <20150210072642.GA27475@qca.qualcomm.com> (sfid-20150210_082706_721294_070316CD)
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1423460814-2767-2-git-send-email-rmanohar@qti.qualcomm.com>
 <54D93A88.8090609@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <54D93A88.8090609@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2015 at 02:54:00PM -0800, Peter Oh wrote:
> 
> On 02/08/2015 09:46 PM, Rajkumar Manoharan wrote:
> Could you explain why the value of nentries are different?
There are separate copy engine configuration tables for host
and target. Host-side and Target-side configurations are different
and it never be same for any CE due to memory constraints in Target.

-Rajkumar
