Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45709 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaAMR3v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:29:51 -0500
Received: by mail-ie0-f182.google.com with SMTP id as1so8377895iec.41
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 09:29:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D3C1CB@HASMSX103.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com>
 <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
 <52828364.6080103@gmail.com> <CAErSpo6JdKgU0M-wu84_U2Hb4-4mdSr_V8f70Pi-ox8H45+Diw@mail.gmail.com>
 <CALkVjQZZVHUxuBkS+ret23Bt61TV_x_kj-ey=y93gC0e3cw__Q@mail.gmail.com>
 <CAErSpo6xCUDqfvKB66nZJYBOWnZLEcSJ39+aTGnKKnuZP6+dRQ@mail.gmail.com>
 <CALkVjQaTnocYnV4GM=LHuYwMRZ=sOZnSrtna4C6anNAWr4O7=A@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02E49@HASMSX103.ger.corp.intel.com>
 <CALkVjQZdPuE2F+ZARBLha-+iOMA4AjDWHO4=ssnuF2Uu87RyuQ@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02EC1@HASMSX103.ger.corp.intel.com>
 <CALkVjQbPTkGuEa8hLVZE0OVatw7ho=D+D51Qu68PRx-0dYay7w@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301E02FC6@HASMSX103.ger.corp.intel.com>
 <CAErSpo6bKOpycD=cp08aBqp2U-u7sdbTSBYoHop1-1Hkmr3F-g@mail.gmail.com>
 <CALkVjQaOHix5uxFGd-62negbfubz-rdP+zmj9w5wDEa1rCA75Q@mail.gmail.com>
 <5285E028.20906@gmail.com> <CALkVjQYT9P--dgez064je4vM-xve4uF5ptOVVk3DuVoQiWQvew@mail.gmail.com>
 <CANUX_P1j9QNGQ2n02KpXsuMQcZo9uOsSN-zZ8yNS1e5+Y9bJOA@mail.gmail.com>
 <CALkVjQYFJzP1E_YayPOjRu3u85WdpDojDD+DmU9ZehY7ZHF0AA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D297F0@HASMSX103.ger.corp.intel.com>
 <CALkVjQaJ94osfBwnrpKBk4tE_+=XMqznXY=qVv5KdzSkvsthaA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D2D2C5@HASMSX103.ger.corp.intel.com>
 <CALkVjQaWBq6--sekifyGfJt9FDigsk56eXMUv9YR3sDVnVcX=Q@mail.gmail.com>
 <CAErSpo4ZxJ8T8ih1+svqjpUNbJo-WezP=9OatDTuLk3u=zkCLw@mail.gmail.com>
 <CALkVjQbjnAk0mFZ-3zjx_15xXEaaiMaVxMMLD1HEUJhVtYXg4g@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB303D3C00A@HASMSX103.ger.corp.intel.com>
 <CALkVjQZ9Tc7Xx9ANzcp_4_7_=BCLM7EHS+oJUxQ57QXuSiv+YA@mail.gmail.com>
 <CALkVjQavGvumxnghCc5R8E=7rzDSy1_q+LVZ=vR6--OJxhp7CA@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303D3C1CB@HASMSX103.ger.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 13 Jan 2014 10:29:30 -0700
Message-ID: <CAErSpo64ttbB7-WYgg2B9seFu5tdSjZqrUSKBKx00GfXzoUDOw@mail.gmail.com> (sfid-20140113_183002_516244_41051E81)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: wzyboy <wzyboy@wzyboy.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Bj?rn Mork" <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[-cc linux-pci]

On Mon, Jan 13, 2014 at 1:26 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> Hi,
>>
>> I am sorry but here is bad news.
>>
>> During previous debugging process, I have a modconf file
>> /etc/modprobe.d/iwlwifi.conf, containing "options iwlmvm
>> power_scheme=1". I removed it just now (Emmanuel says I can remove it
>> now) and encountered (maybe) new bugs. Here is what I did just now:
>>
>> 0. Current kernel: patched with
>> https://bugzilla.kernel.org/attachment.cgi?id=121671&action=diff ;
>> setpci trick: none ; NIC status: works nice after ~16 hours heavy
>> usage.
>> 1. Delete that modconf file, reboot.
>> 2. Network connection becomes painfully laggy and lossy.
>> 3. Re-create that modconf file, reboot.
>> 4. Network connection works fine.
>> 5. Comment out that line, reboot.
>> 6. Network connection becomes painfully laggy and lossy.
>> 7. Uncomment that line, reboot.
>> 8. Network connection works fine.
>>
>> What I mean "painfully laggy and lossy" is that, to whomever I "ping"
>> (Google, 8.8.8.8, local DNS server...), the RTT is rather high than
>> normal, and packet loss rate is above 90% (some addresses 100% loss).
>> While at the same time, other network device in the same LAN works
>> fine.
>>
>> I've attached dmesg and lspci output at step 6 and 8.
>>
>
> Are you sure about step 1 and 5?
> It seems completely weird that an existing file with a line commented out have any impact.

It doesn't seem strange to me; maybe we're interpreting wzyboy's data
differently.  The way I read it, if /etc/modprobe.d/iwlwifi.conf
contains "options iwlmvm power_scheme=1", everything works fine (cases
0, 4, 8).  If iwlwifi.conf does not exist or contains only a
commented-out line, he sees problems (cases 2, 6).

> Can you please send the output of:
>         cat /sys/module/iwlmvm/parameters/power_scheme
> in both cases.
>
> Also - what code base are you using?
> Since  this is surely not related to PCI, please remove them in your reply.
> (I keep them here to have them see my mail :))

Agreed, this doesn't sound PCI-related, so I removed linux-pci.  Feel
free to keep me or add me back if you do see anything PCI-related.

Bjorn
