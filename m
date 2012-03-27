Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:47538 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab2C0QRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 12:17:09 -0400
Message-ID: <4F71E7D2.6040302@windriver.com> (sfid-20120327_181715_502093_43A3FF20)
Date: Wed, 28 Mar 2012 00:16:18 +0800
From: Zhong Hongbo <hongbo.zhong@windriver.com>
MIME-Version: 1.0
To: Zhong Hongbo <hongbo.zhong@windriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<wey-yi.w.guy@intel.com>, <linux-wireless@vger.kernel.org>,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>,
	"'Foglia, Michael'" <Michael.Foglia@windriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Mark Zhan <rongkai.zhan@windriver.com>
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
References: <4F687667.1030605@windriver.com>   <1332247526.3329.17.camel@jlt3.sipsolutions.net>   <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com>  <1332248855.3329.18.camel@jlt3.sipsolutions.net>  <4F6B1D8B.8060306@windriver.com> <1332751883.3511.5.camel@jlt3.sipsolutions.net> <4F71E566.50802@windriver.com>
In-Reply-To: <4F71E566.50802@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2012 12:05 AM, Zhong Hongbo wrote:
> On 03/26/2012 04:51 PM, Johannes Berg wrote:
>> Hi,
>>
>> Sorry for the delay.
>>
>>> Today, I test Intel Centrino N-6205 Taylor Peak on Linux 2.6.39, It work perfect on Windows XP. 
>>> 'PS debugging in ma80211'?, Do you mean that I open the 'CONFIG_MAC80211_DEBUGFS=y' and See the log?
>>> The detail step as following:
>> No, I meant CONFIG_MAC80211_VERBOSE_PS_DEBUG, but given that the iPhone
>> works, I can't convince myself that powersave could be the issue.
>>
>> Maybe you could enable CONFIG_MAC80211_HT_DEBUG instead and see if it's
>> related to aggregation?
> Hi Johannes,
>
> At first, Thanks for your advise. I paste the syslog for windows xp.
> I found I can ping the www.google.com, But I can not browse the web size.
>
iphone connect to the AP and go to internet, I get a part log as the following:

wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 1)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 2)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 3)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 4)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 5)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 6)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 7)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 8)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 9)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 10)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 11)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 12)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 13)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 14)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 15)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 16)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 17)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/18 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 1)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 2)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 3)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 4)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 5)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 6)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 7)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 8)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 9)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 10)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 11)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 12)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 13)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 14)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 15)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 16)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 17)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 18)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 19)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 20)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 21)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 22)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 23)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/24 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 1)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/2 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 0)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 1)
STA 60:fa:cd:09:d7:d3 aid 1: PS buffer (entries before 2)
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/3 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 exits power save mode
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
wlan0: STA 60:fa:cd:09:d7:d3 aid 1 enters power save mode

Thanks,
hongbo

>
> Mar 23 12:44:48 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:44:48 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:44:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:44:50 localhost last message repeated 3 times
> Mar 23 12:44:51 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:44:53 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:44:53 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:44:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:44:55 localhost last message repeated 3 times
> Mar 23 12:44:56 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:44:58 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:44:58 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:44:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:00 localhost last message repeated 3 times
> Mar 23 12:45:01 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:45:02 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:45:02 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:45:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:02 localhost kernel: br0: port 1(wlan0) entering learning state
> Mar 23 12:45:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:04 localhost last message repeated 2 times
> Mar 23 12:45:05 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:45:07 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:45:07 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:45:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:09 localhost last message repeated 3 times
> Mar 23 12:45:10 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:45:12 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:45:12 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:45:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:13 localhost last message repeated 2 times
> Mar 23 12:45:13 localhost kernel: br0: no IPv6 routers present
> Mar 23 12:45:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:15 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: deauthenticated due to local deauth request
> Mar 23 12:45:16 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: authenticated
> Mar 23 12:45:16 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a IEEE 802.11: associated (aid 1)
> Mar 23 12:45:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:17 localhost kernel: br0: port 1(wlan0) entering forwarding state
> Mar 23 12:45:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:18 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a RADIUS: starting accounting session 4F6C702C-00000000
> Mar 23 12:45:18 localhost hostapd: wlan0: STA 00:1f:e2:cc:f5:0a WPA: pairwise key handshake completed (RSN)
> Mar 23 12:45:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:48 localhost dhcpd: Internet Systems Consortium DHCP Server 4.2.1-P1
> Mar 23 12:45:48 localhost dhcpd: Copyright 2004-2011 Internet Systems Consortium.
> Mar 23 12:45:48 localhost dhcpd: All rights reserved.
> Mar 23 12:45:48 localhost dhcpd: For info, please visit https://www.isc.org/software/dhcp/
> Mar 23 12:45:48 localhost dhcpd: Wrote 0 leases to leases file.
> Mar 23 12:45:48 localhost dhcpd: Listening on LPF/br0/a0:88:b4:18:64:a0/192.168.0.0/24
> Mar 23 12:45:48 localhost dhcpd: Sending on   LPF/br0/a0:88:b4:18:64:a0/192.168.0.0/24
> Mar 23 12:45:48 localhost dhcpd: 
> Mar 23 12:45:48 localhost dhcpd: No subnet declaration for eth0 (128.224.163.192).
> Mar 23 12:45:48 localhost dhcpd: ** Ignoring requests on eth0.  If this is not what
> Mar 23 12:45:48 localhost dhcpd:    you want, please write a subnet declaration
> Mar 23 12:45:48 localhost dhcpd:    in your dhcpd.conf file for the network segment
> Mar 23 12:45:48 localhost dhcpd:    to which interface eth0 is attached. **
> Mar 23 12:45:48 localhost dhcpd: 
> Mar 23 12:45:48 localhost dhcpd: Sending on   Socket/fallback/fallback-net
> Mar 23 12:45:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:57 localhost dhcpd: DHCPDISCOVER from 00:1f:e2:cc:f5:0a via br0
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:58 localhost dhcpd: DHCPOFFER on 192.168.0.52 to 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0
> Mar 23 12:45:58 localhost dhcpd: DHCPREQUEST for 192.168.0.52 (192.168.0.1) from 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0
> Mar 23 12:45:58 localhost dhcpd: DHCPACK on 192.168.0.52 to 00:1f:e2:cc:f5:0a (PEK-IT-L5) via br0
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:45:59 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:45:59 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:45:59 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:15 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:15 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:15 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:16 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:16 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:16 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 1 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:46:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:46:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:46:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:00 localhost kernel: nf_conntrack version 0.5.0 (7776 buckets, 31104 max)
> Mar 23 12:47:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:00 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:03 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:05 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:06 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 1)
> Mar 23 12:47:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/2 PS frames since STA not sleeping anymore
> Mar 23 12:47:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:12 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:21 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:24 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:24 localhost last message repeated 2 times
> Mar 23 12:47:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:27 localhost last message repeated 3 times
> Mar 23 12:47:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 1 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:33 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:41 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:44 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:50 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:47:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:47:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:47:57 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:47:58 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:02 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:07 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:23 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 1 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:31 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:32 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:37 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:43 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:44 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:48:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:45 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:48:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:48:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:48:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:03 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:03 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:05 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:06 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:06 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:07 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:08 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:08 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:11 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:12 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:12 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:13 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:14 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:17 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:23 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:24 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:32 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:34 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:35 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:36 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:41 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:44 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:44 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:46 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:46 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:49 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:50 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:50 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:51 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:53 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:54 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:55 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:49:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:49:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:49:56 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:01 localhost crond[873]: (root) CMD (/usr/lib/sa/sa1 -d 1 1)
> Mar 23 12:50:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:01 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:02 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:02 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:04 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:09 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:10 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:18 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:19 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:19 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:20 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:22 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:22 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:24 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:24 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:25 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:26 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:27 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:28 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:28 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:29 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:30 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:33 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 1 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:37 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:38 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:39 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:40 localhost kernel: STA 00:1f:e2:cc:f5:0a aid 1: PS buffer (entries before 0)
> Mar 23 12:50:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/1 PS frames since STA not sleeping anymore
> Mar 23 12:50:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:40 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:41 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:42 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:47 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:48 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
> Mar 23 12:50:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 exits power save mode
> Mar 23 12:50:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
> Mar 23 12:50:52 localhost kernel: wlan0: STA 00:1f:e2:cc:f5:0a aid 1 enters power save mode
>
>
> Thanks,
> hongbo
>
>> johannes
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

