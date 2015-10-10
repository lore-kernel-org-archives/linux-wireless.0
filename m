Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbbJJTMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 15:12:07 -0400
Date: Sat, 10 Oct 2015 12:12:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jacob Kiefer <jtk54@cornell.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	"open list:STAGING - REALTEK RTL8723U WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] staging: rtl8723au: Fix sparse errors in
 rtl8723a_cmd.c
Message-ID: <20151010191204.GA20224@kroah.com> (sfid-20151010_211222_151246_5C6C0D51)
References: <1444105958-32087-1-git-send-email-jtk54@cornell.edu>
 <20151006231134.GV22011@ZenIV.linux.org.uk>
 <20151010185043.GA20030@jtk54-Q550LF>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151010185043.GA20030@jtk54-Q550LF>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 10, 2015 at 02:50:44PM -0400, Jacob Kiefer wrote:
> Hello
> 
> This patch set fixes the same sparse errors as v2, taking Al's
> advice into consideration and changing the interfaces to little-endian.

Please resend these in a format that I can apply them in (i.e. one patch
per email in a series, like you see on the mailing list.)

thanks,

greg k-h
