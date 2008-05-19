Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:9972 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYESNKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 09:10:47 -0400
Received: by wr-out-0506.google.com with SMTP id c48so701071wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 May 2008 06:10:46 -0700 (PDT)
Message-ID: <183c1cc10805190610h176cb8fcx54e6755fb5f36cfb@mail.gmail.com> (sfid-20080519_151053_621777_43954549)
Date: Mon, 19 May 2008 09:10:44 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi Makefile issue in compat-wireless-2008-05-18
In-Reply-To: <1211168475.31033.9.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10805181143v526fcc86l4bec27b12805748f@mail.gmail.com>
	 <1211168475.31033.9.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 18, 2008 at 11:41 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Sun, 2008-05-18 at 14:43 -0400, John Goulah wrote:
>> Hello,
>>
>>  Went to install the new version and found that it wasn't installing
>> the iwl4965 driver.  I did a diff against my last good version (back
>> in April so not sure how long its been like this)
>
> We introduced the virtual CONFIG_IWLWIFI in recent wireless-testing. It
> is a tristate when either CONFIG_IWL3945 or CONFIG_IWLCORE is selected.
> It doesn't appear in the old kernel you are compiling against. Maybe
> someone need to make a patch for Kconfig in compact-wireless?
>


Thats odd, my kernel is fairly new -- 2.6.24.4

I custom compiled it, and I dont see anything related to IWL  in my
.config file strangely enough.  I guess its possible my .config got
out of sync somehow, or is this what you would consider "old" ?


Thanks!
John
