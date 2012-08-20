Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59060 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2HTPxu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 11:53:50 -0400
Received: by ggdk6 with SMTP id k6so5136567ggd.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 08:53:49 -0700 (PDT)
Message-ID: <50325D89.9080209@lwfinger.net> (sfid-20120820_175359_118501_EB784972)
Date: Mon, 20 Aug 2012 10:53:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
References: <502D0C72.2050207@lwfinger.net>  (sfid-20120816_170635_404509_F239FBF6) <1345459509.4459.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1345459509.4459.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/20/2012 05:45 AM, Johannes Berg wrote:

Johannes,

> Unfortunately, I can't just release this firmware, it was mostly
> internal experimental builds, we released the -6 version later. However,
> as Thomas pointed out, it should be possible to backport some patches to
> make the driver in 3.1.9 work with the device, that simply wasn't a
> concern for us and it's not entirely clear to me that such patches are
> candidates for stable.

The openSUSE user has gotten his system working by installing the 
compat-wireless package. I do not know if he could patch and compile his own 
kernel, and I don't have that device in my collection, thus I would be unable to 
test any such changes.

I'm still concerned about the bigger picture. I can understand that the -5 
version was experimental, but why was a driver released that needed a firmware 
version that could never be obtained? If any driver version needs a particular 
firmware, the fw must be available as long as anyone might be using that driver. 
To me, that means forever.

Larry


