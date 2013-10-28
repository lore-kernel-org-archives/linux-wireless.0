Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58645 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3J1Uol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 16:44:41 -0400
Received: by mail-wi0-f181.google.com with SMTP id ex4so1924277wid.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 13:44:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de> <CAMP44s2Cvw9HF3c3Asuq+bTSD36Gw6PXOUVjAcCD+hf6KB_awg@mail.gmail.com>
 <CABPxzY+xJ7kst-sYwP8RJwMO_zkNYWKaYy=_LS7WQfuxquK24w@mail.gmail.com>
 <CAMP44s0087jYz5AiEaEzwt7GqH9ed8PWE1CmvMPr4Dqn3yE6rA@mail.gmail.com>
 <CABPxzYLwwyFCFw1pEt0v9Xw4kcue1C_RZx0RbTbMrUw=+MWvgQ@mail.gmail.com> <CAMP44s0svc2MRKCrZXS5ZYRZNPoomQkcKHdC2m2BGy7di+TCyA@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 29 Oct 2013 02:14:20 +0530
Message-ID: <CABPxzYL-Gzbzoc_ui+qUQ6uzoKp=Yq7yLWZvc7PoEjiH3dFczg@mail.gmail.com> (sfid-20131028_214446_690734_A1EBE605)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>, ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 29, 2013 at 1:36 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Oct 28, 2013 at 1:27 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:

>> From the logs we can see that we have received authentication response,
>> so the association request is getting dropped somewhere? We might
>> need the mac80211 and iwlwifi trace-cmd logs to check for the drop.
>>
>> http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing
>
> There you go:
> http://people.freedesktop.org/~felipec/wpa/trace.dat.xz
>
Hmm.."trace-cmd report -i trace.dat" returned lots of errors, i have even
tried with the trace-cmd from git (ubuntu). Did it worked fro you?


===
# trace-cmd report -i trace.dat
version = 6
trace-cmd: No such file or directory ??????????????
  function scsi_trace_parse_cdb not defined
  function scsi_trace_parse_cdb not defined
  function scsi_trace_parse_cdb not defined
  function scsi_trace_parse_cdb not defined
  function is_writable_pte not defined
  function __le16_to_cpup not defined
  function __le16_to_cpup not defined
  function __le16_to_cpup not defined
CPU 0 is empty
CPU 1 is empty
CPU 2 is empty
CPU 3 is empty
cpus=4



-- 
Thanks,
Regards,
Chaitanya T K.
Mobile:+91-9963910010.
