Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:50639 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab2FMTFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 15:05:14 -0400
Received: by lbom4 with SMTP id m4so1938010lbo.30
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 12:05:04 -0700 (PDT)
Message-ID: <1339614302.10534.65.camel@cumari.coelho.fi> (sfid-20120613_210518_023834_3B0E705E)
Subject: Re: [PATCH] wlcore: update basic rates on channel switch
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 22:05:02 +0300
In-Reply-To: <1339494327-28246-1-git-send-email-eliad@wizery.com>
References: <1339494327-28246-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 12:45 +0300, Eliad Peller wrote:
> On channel switch we have to update the basic rates, in
> order to reflect possible band changes (otherwise, we
> might start beaconing on 11a with the default rates
> of 11g).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks Eliad!

--
Luca.

