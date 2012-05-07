Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49140 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2EGI2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 04:28:41 -0400
Date: Mon, 7 May 2012 11:29:47 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: David Miller <davem@davemloft.net>, dh.herrmann@googlemail.com,
	gustavo@padovan.org, linville@tuxdriver.com,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Fix coding style
Message-ID: <20120507082945.GB19002@aemeltch-MOBL1> (sfid-20120507_102846_674699_38DCD179)
References: <1336157988-4602-1-git-send-email-gustavo@padovan.org>
 <20120506.123656.1335354317428258137.davem@davemloft.net>
 <CANq1E4TTfDxZPsOqqWUT7PqTKUr8nCTC-wo=iGe_pxoUmnecgQ@mail.gmail.com>
 <20120506.145304.1998242927519675381.davem@davemloft.net>
 <20120507081411.GA19002@aemeltch-MOBL1>
 <4FA78618.4050203@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA78618.4050203@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Mon, May 07, 2012 at 10:21:44AM +0200, Arend van Spriel wrote:
> On 05/07/2012 10:14 AM, Andrei Emeltchenko wrote:
> >> They don't.  All the examples you'll find are of the form:
> >> > 
> >> > 	if (a &&
> >> > 	    b)
> >> > 
> >> > not:
> >> > 
> >> > 	if (a &&
> >> > 			b)
> > Actually it does not look like this, otherwise "b" would be placed in the
> > same line, don't it?
> 
> Let me rephrase Dave's remark so you may understand:
> 
> 	if (a_has_to_be_long_enough_to_make_you_understand &&
> 	    you_do_not_care_about_code_readability)
> 
> and not:
> 	if (a_has_to_be_long_enough_to_make_you_understand &&
> 			you_do_not_care_about_code_readability)

You seems to forgot to reply to the main question about Codying Style.

Best regards 
Andrei Emeltchenko 

