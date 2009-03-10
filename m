Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:26088 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZCJDcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 23:32:35 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1312965yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 20:32:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1236649234.6685.9.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow>
Date: Mon, 9 Mar 2009 23:32:33 -0400
Message-ID: <c4d76b3b0903092032j4d511b46n13a3d03be00c98e8@mail.gmail.com> (sfid-20090310_043238_417446_76CA0CF2)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 9, 2009 at 9:40 PM, Jason Andryuk <jandryuk@gmail.com> wrote:
> Any thoughts on what could be going wrong?

Mar  9 21:25:03 rainbow kernel: [17666.842650] iwl3945 0000:03:00.0:
iwl3945_post_associate Should not be called in 515 mode

Looks like corruption of some sort.

Jason
