Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35472 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbbFPLLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 07:11:25 -0400
Date: Tue, 16 Jun 2015 16:41:11 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Abdul, Hussain (H.)" <habdul@visteon.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>
Subject: Re: [PATCH] Staging: wilc1000: Boolean tests don't need comparisons
Message-ID: <20150616111111.GA15479@sudip-PC> (sfid-20150616_131131_531449_002788D5)
References: <1434439941-6369-1-git-send-email-habdul@visteon.com>
 <20150616080955.GA1007@sudip-PC>
 <DB5PR06MB1112E576BF6FFE240CB124C0DFA70@DB5PR06MB1112.eurprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DB5PR06MB1112E576BF6FFE240CB124C0DFA70@DB5PR06MB1112.eurprd06.prod.outlook.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 08:55:13AM +0000, Abdul, Hussain (H.) wrote:
> On Tuesday 16 June 2015 01:40 PM, Sudip Mukherjee wrote:
> > On Tue, Jun 16, 2015 at 07:33:42AM +0000, Abdul, Hussain (H.) wrote:
> >> From: Abdul Hussain <habdul@visteon.com>
> >
> > regards
> > sudip
> >
> Sudip,
> 
> Yes that is an assignment to the boolean variable. Do i need to modify the commit message or to send separate patch?
if that assignment is related to the change in boolean test then it should
be in the same patch. But in any case commit message should mention that
change and the reason.

regards
sudip

