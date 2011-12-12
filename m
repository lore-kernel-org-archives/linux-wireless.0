Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47188 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750864Ab1LLKJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 05:09:27 -0500
Message-ID: <4EE5D2D3.406@gmx.net> (sfid-20111212_110930_856647_E18977B0)
Date: Mon, 12 Dec 2011 11:09:23 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>  <4EE35877.1060507@gmx.net> (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323680657.3442.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/12/11 10:04, Johannes Berg wrote:
> Are you running a 32-bit kernel on a 64-bit machine by any chance?
> Somebody else reported that using a 64-bit kernel helped similar issues.

That's right. It's F16.i686 on a
# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i5 CPU       M 540  @ 2.53GHz
stepping	: 5
stepping	: 5
cpu MHz		: 1199.000
cache size	: 3072 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni
pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm
sse4_1 sse4_2 popcnt aes lahf_lm ida arat dts tpr_shadow vnmi
flexpriority ept vpid
bogomips	: 5053.69
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

VT is enabled in BIOS (what's not default on that model).

Greetings, Wolfgang
