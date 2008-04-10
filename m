Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32798 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355AbYDJVlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 17:41:39 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] MAINTAINERS: move to generic repository for iwlwifi
Date: Thu, 10 Apr 2008 14:41:37 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004289EFD@orsmsx416.amr.corp.intel.com> (sfid-20080410_224143_927658_93DBEA7A)
In-Reply-To: <20080410212935.GA29639@tuxdriver.com>
References: <1207858587-14503-1-git-send-email-reinette.chatre@intel.com> <20080410212935.GA29639@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , linux-wireless-owner@vger.kernel.org  wrote:

> On Thu, Apr 10, 2008 at 01:16:27PM -0700, Reinette Chatre wrote:
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com> ---
>> John,
>> 
>> Is it possible to get this laggard into 2.6.25?
>> 
>>  MAINTAINERS |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 9e63f16..d7c62b2 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -2116,7 +2116,7 @@ M:	reinette.chatre@intel.com
>>  L:	linux-wireless@vger.kernel.org
>>  L:	ipw3945-devel@lists.sourceforge.net
>>  W:	http://intellinuxwireless.org
>> -T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
>> +T:	git kernel.org:/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
>>  S:	Supported
> 
> Shouldn't this look like below?
> 
> -T:   git
> git://git.kernel.org/pub/scm/linux/kernel/git/rchatre/iwlwifi-2.6.git
> +T:   git
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git 

I grepped for "git" in MAINTAINERS and the majority seems to be
formatted as in this patch. In the end I went with the same format used
by "NETWORKING [WIRELESS]" and "NETWORK DEVICE DRIVERS". So ... I don't
know if this is the _right_ way, but at least we are now in good company
:)

Reinette
