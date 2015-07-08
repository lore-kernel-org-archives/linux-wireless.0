Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:34939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbbGHQmE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 12:42:04 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Nicholas Krause <xerofoify@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [linuxwifi] [PATCH] iwlwifi:Make various functions void in the
 file rs.c
Date: Wed, 8 Jul 2015 16:41:58 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7A24CF@hasmsx107.ger.corp.intel.com> (sfid-20150708_184221_834837_C64DE6C1)
References: <1436367735-27148-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 07/08/2015 06:03 PM, Nicholas Krause wrote:
> This makes various functions in the file rs.c void due to these
> functions never returning a error code to signal to their callers
> if and how they have failed to complete their intended work.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

I picked it up in our internal repository.
Thanks.
