Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web33009.mail.mud.yahoo.com ([209.191.69.124]:46089 "HELO
	web33009.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755507AbXKZEAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 23:00:07 -0500
Date: Sun, 25 Nov 2007 20:00:05 -0800 (PST)
From: Max <maxw_gcc@yahoo.com>
Subject: Re: Error compiling intel mac80211-10.0.2
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <442384.57879.qm@web33009.mail.mud.yahoo.com> (sfid-20071126_040012_890866_67C290C7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-11-24 at 22:34 -0800, Max wrote:
>> Hi all,
>> 
>> I am trying to setup a Intel Corporation PRO/Wireless 3945ABG network
 adapter using the software provided in
 http://www.intellinuxwireless.org/. But I am getting the following
 error:

On Sun, November 25, 2007 8:35:07 PM Zhu wrote:
>Since this question doesn't relate to upstream mac80211, I'd suggest
 you
>only post it to ipw3945-devel@lists.sourceforge.net.

Thanks for the suggestion. I will do that.

>> ...
>> Checking kernel compatibility in:
>>         /lib/modules/2.6.18/source//
>>   ! CONFIG_NET_WIRELESS_NETLINK can not be set in .config!
>> ...
>> 
>> Which apparently gets triggered by the following lines in the
 "../mac80211-10.0.2/scripts/determine_compat" script
>> .....
>>         grep -q "nlmsg_trim" \
>>                 ${KSRC}include/net/netlink.h && {
>>                 export has_nlmsg_trim=1
>>         } || {
>>                 grep -q "^CONFIG_NET_WIRELESS_RTNETLINK=[ym]" \
>>                         ${KSRC}.config && {
>>                         echo "  ! CONFIG_NET_WIRELESS_NETLINK can not
 be set in .config!"
>>                         exit 1
>>                 }
>>         }
>> ......
>> 
>> As you can see I am running kernel version 2.6.18.

>The code mac80211-10.0.2 integrated doesn't work with
>CONFIG_NET_WIRELESS_RTNETLINK enabled. You should deselect it from your
>kernel config file.
>Thanks,
>-yi

I was afraid of any ill side effects and I was looking for confirmation, which you gave me. Thanks for your help.

Max




      ____________________________________________________________________________________
Be a better pen pal. 
Text or chat with friends inside Yahoo! Mail. See how.  http://overview.mail.yahoo.com/
