Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:38908 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751667AbbCGFXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 00:23:37 -0500
Message-ID: <1425705814.12017.68.camel@perches.com> (sfid-20150307_062340_909376_A6E2AAC7)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Fri, 06 Mar 2015 21:23:34 -0800
In-Reply-To: <wrfj7futwfl5.fsf@ultrasam.lan.trained-monkey.org>
References: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425680126-25928-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1425682797.12017.58.camel@perches.com>
	 <wrfj7futwfl5.fsf@ultrasam.lan.trained-monkey.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-03-07 at 00:18 -0500, Jes Sorensen wrote:
> The long strings are an outright nack.

Pity.  There's a specific exclusion in CodingStyle.

	Chapter 2: Breaking long lines and strings

never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.

