Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:48093 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYF2V5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 17:57:07 -0400
Received: by wa-out-1112.google.com with SMTP id j37so994053waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jun 2008 14:57:05 -0700 (PDT)
Subject: Re: [RFC PATCH 19/19] orinoco: Add MIC on TX and check on RX
From: Harvey Harrison <harvey.harrison@gmail.com>
To: kilroyd@googlemail.com
Cc: linux-wireless@vger.kernel.org, proski@gnu.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
In-Reply-To: <1214678305-7057-20-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-16-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-17-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-18-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-19-git-send-email-kilroyd@gmail.com>
	 <1214678305-7057-20-git-send-email-kilroyd@gmail.com>
Content-Type: text/plain
Date: Sun, 29 Jun 2008 14:56:48 -0700
Message-Id: <1214776609.6037.11.camel@brick> (sfid-20080629_235718_050248_F270D991)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-06-28 at 19:38 +0100, kilroyd@googlemail.com wrote:
> Use the MIC algorithm from the crypto subsystem.
> 
> Signed-off-by: David Kilroy <kilroyd@gmail.com>

Any reason not to use the net/mac80211/michael.c implementation?

Cheers,

Harvey


