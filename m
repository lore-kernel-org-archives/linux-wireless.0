Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:40011 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760488Ab3DJOHw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 10:07:52 -0400
Message-Id: <1365602871.18841.140661215878141.084B3828@webmail.messagingengine.com> (sfid-20130410_160756_676473_5B28A7F8)
From: =?UTF-8?Q?K=C3=A9vin=20THIERRY?= <kevinthierry@myopera.com>
To: Gagan Goyal <gagsbond@gmail.com>
Cc: linux-wireless@vger.kernel.org, ronan.lanoe@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
In-Reply-To: <CAChKcEn7=Lk8nGOaYm9=gsTJbdSntDzdEJrpUmh65OC10AFWsg@mail.gmail.com>
References: <1365157014.26961.140661213699557.09D0C440@webmail.messagingengine.com>
 <CAChKcEn7=Lk8nGOaYm9=gsTJbdSntDzdEJrpUmh65OC10AFWsg@mail.gmail.com>
Subject: Re: Wifi P2P : go negociation fails
Date: Wed, 10 Apr 2013 14:07:51 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gagan,

Here is the result with wait set to 0.
This time the devices never stopped to try to connect to each other, I
had to enter "p2p_stop_find" to stop them.
No result was displayed in the wpa_cli interface after the connect
command was entered.

--------------------------------------------------------------------------------------------------
     50 32 50 5f 43 4f 4e 4e 45 43 54 20 31 30 3a 30   P2P_CONNECT 10:0
     64 3a 37 66 3a 62 34 3a 31 64 3a 37 63 20 70 62   d:7f:b4:1d:7c pb
     63 20 67 6f 5f 69 6e 74 65 6e 74 3d 31 35         c go_intent=15  
wlan2: Control interface command 'P2P_CONNECT 10:0d:7f:b4:1d:7c pbc
go_intent=15'
nl80211: Get shared freq for PHY phy0
nl80211: No shared interface for PHY (phy0) in associated state
wlan2: P2P: Own frequency preference: 0 MHz
wlan2: P2P: Request to start group negotiation - peer=10:0d:7f:b4:1d:7c 
GO Intent=15  Intended Interface Address=10:0d:7f:b9:ae:77 wps_method=3
persistent_group=0 pd_before_go_neg=0
wlan2: P2P: Own preference for operation channel: Operating Class 81
Channel 1
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Capability dev=21 group=08
P2P: * GO Intent: Intent 15 Tie breaker 1
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: * Listen Channel: Regulatory Class 81 Channel 1
P2P: * Intended P2P Interface Address 10:0d:7f:b9:ae:77
P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05 06
07 08 09 0a 0b
P2P: * Device Info
P2P: * Operating Channel: Regulatory Class 81 Channel 1
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * Version2 (0x20)
wlan2: P2P: Sending GO Negotiation Request
wlan2: P2P: State IDLE -> CONNECT
Off-channel: Send action frame: freq=2437 dst=10:0d:7f:b4:1d:7c
src=10:0d:7f:b9:ae:77 bssid=10:0d:7f:b4:1d:7c len=132
nl80211: Send Action frame (ifindex=3, freq=2437 MHz wait=500 ms
no_cck=1)
nl80211: CMD_FRAME freq=2437 wait=0 no_cck=1 no_ack=0 offchanok=1
nl80211: Frame TX command accepted; cookie 0xf640ec30
nl80211: Event message available
nl80211: MLME event 60
nl80211: MLME event frame - hexdump(len=156): d0 00 00 00 10 0d 7f b4 1d
7c 10 0d 7f b9 ae 77 10 0d 7f b4 1d 7c 00 00 04 09 50 6f 9a 09 00 01 dd
5f 50 6f 9a 09 02 02 00 21 08 04 01 00 1f 05 02 00 64 14 06 05 00 58 58
04 51 01 09 06 00 10 0d 7f b9 ae 77 0b 10 00 58 58 04 51 0b 01 02 03 04
05 06 07 08 09 0a 0b 0d 1e 00 10 0d 7f b9 ae 77 00 80 00 01 00 50 f2 04
00 01 00 10 11 00 09 38 31 39 32 43 55 5f 50 43 11 05 00 58 58 04 51 01
dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 04 10 49 00 06 00 37 2a
00 01 20
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0f640ec30 (match) (ack=1)
wlan2: Event TX_STATUS (18) received
wlan2: EVENT_TX_STATUS dst=10:0d:7f:b4:1d:7c type=0 stype=13
Off-channel: TX status result=0 cb=0x80665e0
wlan2: P2P: Action frame TX callback (state=1 freq=2437
dst=10:0d:7f:b4:1d:7c src=10:0d:7f:b9:ae:77 bssid=10:0d:7f:b4:1d:7c
result=0
wlan2: P2P: GO Negotiation Request TX callback: success=1
wlan2: P2P: State CONNECT -> CONNECT
wlan2: P2P: Set timeout (state=CONNECT): 0.500000 sec
wlan2: P2P: Timeout (state=CONNECT)
Off-channel: Action frame sequence done notification
nl80211: Cancel TX frame wait: cookie=0xf640ec30
nl80211: wait cancel failed: ret=-95 (Operation not supported)
wlan2: P2P: State CONNECT -> CONNECT_LISTEN
wlan2: P2P: Starting short listen state (state=CONNECT_LISTEN)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=21 group=00
P2P: * Device Info
nl80211: Enable Probe Request reporting nl_preq=0x8c70018
nl80211: Register frame type=0x40 nl_handle=0x8c70018
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Remain-on-channel cookie 0x3e9aca000 for freq=2412 MHz
duration=307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=0 freq=2412 channel_type=0
duration=307 cookie=0x3e9aca000 (match))
wlan2: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=0
pending_action_tx=(nil))
wlan2: P2P: Starting Listen timeout(0,307200) on freq=2412 based on
callback
wlan2: P2P: Set timeout (state=CONNECT_LISTEN): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=1 freq=2412 channel_type=0
duration=0 cookie=0x3e9aca000 (match))
wlan2: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
pending_action_tx=(nil))
wlan2: P2P: Driver ended Listen state (freq=2412)
wlan2: P2P: Timeout (state=CONNECT_LISTEN)
wlan2: P2P: State CONNECT_LISTEN -> CONNECT
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Capability dev=21 group=08
P2P: * GO Intent: Intent 15 Tie breaker 1
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: * Listen Channel: Regulatory Class 81 Channel 1
P2P: * Intended P2P Interface Address 10:0d:7f:b9:ae:77
P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05 06
07 08 09 0a 0b
P2P: * Device Info
P2P: * Operating Channel: Regulatory Class 81 Channel 1
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * Version2 (0x20)
wlan2: P2P: Sending GO Negotiation Request
wlan2: P2P: State CONNECT -> CONNECT
Off-channel: Send action frame: freq=2437 dst=10:0d:7f:b4:1d:7c
src=10:0d:7f:b9:ae:77 bssid=10:0d:7f:b4:1d:7c len=132
nl80211: Send Action frame (ifindex=3, freq=2437 MHz wait=500 ms
no_cck=1)
nl80211: CMD_FRAME freq=2437 wait=0 no_cck=1 no_ack=0 offchanok=1
nl80211: Frame TX command accepted; cookie 0xf640ea30
nl80211: Event message available
nl80211: MLME event 60
nl80211: MLME event frame - hexdump(len=156): d0 00 00 00 10 0d 7f b4 1d
7c 10 0d 7f b9 ae 77 10 0d 7f b4 1d 7c 00 00 04 09 50 6f 9a 09 00 01 dd
5f 50 6f 9a 09 02 02 00 21 08 04 01 00 1f 05 02 00 64 14 06 05 00 58 58
04 51 01 09 06 00 10 0d 7f b9 ae 77 0b 10 00 58 58 04 51 0b 01 02 03 04
05 06 07 08 09 0a 0b 0d 1e 00 10 0d 7f b9 ae 77 00 80 00 01 00 50 f2 04
00 01 00 10 11 00 09 38 31 39 32 43 55 5f 50 43 11 05 00 58 58 04 51 01
dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 04 10 49 00 06 00 37 2a
00 01 20
nl80211: Frame TX status event
nl80211: Action TX status: cookie=0f640ea30 (match) (ack=1)
wlan2: Event TX_STATUS (18) received
wlan2: EVENT_TX_STATUS dst=10:0d:7f:b4:1d:7c type=0 stype=13
Off-channel: TX status result=0 cb=0x80665e0
wlan2: P2P: Action frame TX callback (state=1 freq=2437
dst=10:0d:7f:b4:1d:7c src=10:0d:7f:b9:ae:77 bssid=10:0d:7f:b4:1d:7c
result=0
wlan2: P2P: GO Negotiation Request TX callback: success=1
wlan2: P2P: State CONNECT -> CONNECT
wlan2: P2P: Set timeout (state=CONNECT): 0.500000 sec
wlan2: P2P: Timeout (state=CONNECT)
Off-channel: Action frame sequence done notification
nl80211: Cancel TX frame wait: cookie=0xf640ea30
nl80211: wait cancel failed: ret=-95 (Operation not supported)
wlan2: P2P: State CONNECT -> CONNECT_LISTEN
wlan2: P2P: Starting short listen state (state=CONNECT_LISTEN)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 4
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=21 group=00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=0x8c70018
nl80211: Remain-on-channel cookie 0x3e9aca000 for freq=2412 MHz
duration=102
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=0 freq=2412 channel_type=0
duration=102 cookie=0x3e9aca000 (match))
wlan2: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=0
pending_action_tx=(nil))
wlan2: P2P: Starting Listen timeout(0,102400) on freq=2412 based on
callback
wlan2: P2P: Set timeout (state=CONNECT_LISTEN): 0.122400 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=1 freq=2412 channel_type=0
duration=0 cookie=0x3e9aca000 (match))
wlan2: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
pending_action_tx=(nil))
wlan2: P2P: Driver ended Listen state (freq=2412)
wlan2: P2P: Timeout (state=CONNECT_LISTEN)
wlan2: P2P: State CONNECT_LISTEN -> CONNECT

I hope this helps,

Kevin

On Tue, Apr 9, 2013, at 03:36 AM, Gagan Goyal wrote:
> Hi Kevin,
> 
> in the logs:
> nl80211: CMD_FRAME freq=2412 wait=500 no_cck=1 no_ack=0 offchanok=1
> nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=2412
> wait=500)
> 
> the frame cmd is failing with error -22. it seems that GO negotiation
> request is not sent on air.
> 
> Could you plz try with wait set to 0 instead of 500msec?
> 
> 
> Regards
> 
> Gagan
> On 4/5/13, Kévin THIERRY <kevinthierry@myopera.com> wrote:
> > Hi !
> >
> > I've been trying to setup a connection between two devices using WiFi
> > P2P.
> > I'm using two Netgear N150 Wifi dongles (chipset Realtek 8192CU).
> > Using the latest driver from Realtek (v.3.4.4) and the latest version of
> > wpa_supplicant from git repository the GO negociation fails while trying
> > to connect.
> > I'm working on XUbuntu (32 bit) 11.04 with kernel 2.6.38 on both
> > machines.
> >
> > .config file to build wpa_supplicant :
> > --------------------------------------------------------------------
> > CONFIG_DRIVER_NL80211=y
> > CONFIG_CTRL_IFACE=y
> > CONFIG_WPS=y
> > CONFIG_WPS2=y
> > CONFIG_P2P=y
> > CONFIG_AP=y
> >
> > wpa_supplicant.conf used to launch wpa_supplicant (sudo ./wpa_supplicant
> > -Dnl80211 -c./wpa_supplicant.conf -iwlan2 -dd) :
> > --------------------------------------------------------------------
> > ctrl_interface=/var/run/wpa_supplicant
> > ap_scan=1
> > device_name=8192CU_PC
> > device_type=1-0050F204-1
> >
> > Steps followed :
> > --------------------------------------------------------------------
> > Device 1 >> p2p_find 5
> > Device 2 >> p2p_find 5
> > Device 1 >> p2p_connect 10:0d:7f:b9:ae:77 pbc go_intent=15
> > Device 2 >> p2p_connect 10:0d:7f:b4:1d:7d pbc
> >
> > wpa_cli logs on device 1:
> > --------------------------------------------------------------------
> >> p2p_find 5
> > OK
> > <3>P2P-DEVICE-FOUND 10:0d:7f:b9:ae:77 p2p_dev_addr=10:0d:7f:b9:ae:77
> > pri_dev_type=30-0050F204-1 name='Realtek DMP Device'
> > config_methods=0x188 dev_capab=0x20 group_capab=0x0
> > <3>P2P-FIND-STOPPED
> >> p2p_connect 10:0d:7f:b9:ae:77 pbc go_intent=15
> > OK
> > <3>P2P-GO-NEG-FAILURE status=-1
> >
> > wap_suplicant logs on device 1 :
> > --------------------------------------------------------------------
> > RX ctrl_iface - hexdump_ascii(len=46):
> >      50 32 50 5f 43 4f 4e 4e 45 43 54 20 31 30 3a 30   P2P_CONNECT 10:0
> >      64 3a 37 66 3a 62 39 3a 61 65 3a 37 37 20 70 62   d:7f:b9:ae:77 pb
> >      63 20 67 6f 5f 69 6e 74 65 6e 74 3d 31 35         c go_intent=15
> > wlan2: Control interface command 'P2P_CONNECT 10:0d:7f:b9:ae:77 pbc
> > go_intent=15'
> > nl80211: Get shared freq for PHY phy5
> > nl80211: No shared interface for PHY (phy5) in associated state
> > wlan2: P2P: Own frequency preference: 0 MHz
> > wlan2: P2P: Request to start group negotiation - peer=10:0d:7f:b9:ae:77
> > GO Intent=15  Intended Interface Address=10:0d:7f:b4:1d:7d wps_method=3
> > persistent_group=0 pd_before_go_neg=0
> > wlan2: P2P: Own preference for operation channel: Operating Class 81
> > Channel 1
> > P2P: * Dialog Token: 1
> > P2P: * P2P IE header
> > P2P: * Capability dev=21 group=08
> > P2P: * GO Intent: Intent 15 Tie breaker 1
> > P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
> > P2P: * Listen Channel: Regulatory Class 81 Channel 6
> > P2P: * Intended P2P Interface Address 10:0d:7f:b4:1d:7d
> > P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05 06
> > 07 08 09 0a 0b
> > P2P: * Device Info
> > P2P: * Operating Channel: Regulatory Class 81 Channel 1
> > WPS:  * Version (hardcoded 0x10)
> > P2P: WPS IE Device Password ID: 4
> > WPS:  * Version2 (0x20)
> > wlan2: P2P: Sending GO Negotiation Request
> > wlan2: P2P: State IDLE -> CONNECT
> > Off-channel: Send action frame: freq=2412 dst=10:0d:7f:b9:ae:77
> > src=10:0d:7f:b4:1d:7d bssid=10:0d:7f:b9:ae:77 len=132
> > nl80211: Send Action frame (ifindex=10, freq=2412 MHz wait=500 ms
> > no_cck=1)
> > nl80211: CMD_FRAME freq=2412 wait=500 no_cck=1 no_ack=0 offchanok=1
> > nl80211: Frame command failed: ret=-22 (Invalid argument) (freq=2412
> > wait=500)
> > wlan2: P2P: Failed to send Action frame
> > wlan2: P2P: Set timeout (state=CONNECT): 0.000000 sec
> > wlan2: P2P: Timeout (state=CONNECT)
> > Off-channel: Action frame sequence done notification
> > nl80211: Cancel TX frame wait: cookie=0x0
> > nl80211: wait cancel failed: ret=-95 (Operation not supported)
> > wlan2: P2P: State CONNECT -> CONNECT_LISTEN
> > wlan2: P2P: Starting short listen state (state=CONNECT_LISTEN)
> > WPS:  * Version (hardcoded 0x10)
> > P2P: WPS IE Device Password ID: 4
> > WPS:  * UUID-E
> > WPS:  * Version2 (0x20)
> > P2P: * P2P IE header
> > P2P: * Capability dev=21 group=00
> > P2P: * Device Info
> > nl80211: Enable Probe Request reporting nl_preq=0x9335010
> > nl80211: Register frame type=0x40 nl_handle=0x9335010
> > nl80211: Register frame match - hexdump(len=0): [NULL]
> > nl80211: Remain-on-channel cookie 0xaeefcc000 for freq=2437 MHz
> > duration=204
> > nl80211: Event message available
> > nl80211: Remain-on-channel event (cancel=0 freq=2437 channel_type=0
> > duration=204 cookie=0xaeefcc000 (match))
> > wlan2: Event REMAIN_ON_CHANNEL (22) received
> > Off-channel: Send Action callback (without_roc=0
> > pending_action_tx=(nil))
> > wlan2: P2P: Starting Listen timeout(0,204800) on freq=2437 based on
> > callback
> > wlan2: P2P: Set timeout (state=CONNECT_LISTEN): 0.224800 sec
> > nl80211: Event message available
> > nl80211: Remain-on-channel event (cancel=1 freq=2437 channel_type=0
> > duration=0 cookie=0xaeefcc000 (match))
> > wlan2: Event CANCEL_REMAIN_ON_CHANNEL (23) received
> > P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
> > pending_action_tx=(nil))
> > wlan2: P2P: Driver ended Listen state (freq=2437)
> > wlan2: P2P: Timeout (state=CONNECT_LISTEN)
> > wlan2: P2P: State CONNECT_LISTEN -> CONNECT
> > [...]
> > wlan2: P2P: Timeout on sending GO Negotiation Request without getting
> > response
> > wlan2: P2P: Clear timeout (state=CONNECT_LISTEN)
> > wlan2: P2P: State CONNECT_LISTEN -> IDLE
> > wlan2: P2P-GO-NEG-FAILURE status=-1
> > CTRL_IFACE monitor send - hexdump(len=21): 2f 74 6d 70 2f 77 70 61 5f 63
> > 74 72 6c 5f 36 33 39 36 2d 32 00
> >
> > Logs from device 2 are identical.
> >
> > Do you have an idea about where this come from ?
> >
> > Thank you,
> >
> > Kévin
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
