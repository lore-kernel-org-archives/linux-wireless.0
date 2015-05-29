Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:53530 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613AbbE2MGI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 08:06:08 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>
Subject: Re: [PATCHv3 09/16] mwifiex: add sta_list firmware command
References: <1432918598-27769-1-git-send-email-patila@marvell.com>
	<1432918598-27769-10-git-send-email-patila@marvell.com>
Date: Fri, 29 May 2015 14:05:56 +0200
In-Reply-To: <1432918598-27769-10-git-send-email-patila@marvell.com> (Avinash
	Patil's message of "Fri, 29 May 2015 22:26:30 +0530")
Message-ID: <87382fh9ln.fsf@nemi.mork.no> (sfid-20150529_140613_043311_8C55877B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avinash Patil <patila@marvell.com> writes:

>  		case HostCmd_CMD_UAP_BSS_STOP:
>  		case HostCmd_CMD_UAP_STA_DEAUTH:
>  		case HOST_CMD_APCMD_SYS_RESET:
> +		case HOSTCMD_CMD_UAP_STA_LIST:


Just wondering, not really objecting.... But wouldn't it be nice with
some consistency here?


Bjørn
