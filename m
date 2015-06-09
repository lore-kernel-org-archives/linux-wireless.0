Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbFIRja (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 13:39:30 -0400
Date: Tue, 9 Jun 2015 10:39:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] staging: wilc1000: Cleanup to coreconfigurator
Message-ID: <20150609173929.GA22547@kroah.com> (sfid-20150609_193933_914918_7A637485)
References: <1433796869-2737-1-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433796869-2737-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 08, 2015 at 11:54:28PM +0300, Stanislav Kholmanskikh wrote:
> Fixed the following issues found with checkpatch.pl:
> 
> * Multiple debug strings contained " \n". Changed
>   it to "\n".
> 
> * Changed 'return(X)' to 'return X'.
> 
> * Aligned TAG_PARAM_OFFSET to fit 80 columns

That is 3 different things, please make this 3 different patches.
Remember, each patch can only do one thing.

thanks,

greg k-h
